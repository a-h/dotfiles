# nixpkgs still packages betaflight-configurator 10.10.0, released 2024-04-28,
# by unpacking the linux64-portable.zip from that release - the last of the
# NW.js builds. Upstream has since switched to calendar versioning and to a
# Tauri shell, and is on 2026.6.1; nixpkgs-unstable is on 10.10.0 too, so there
# is no newer channel to move to. This builds the current release instead.
#
# It is two build systems in one derivation. npm/vite compiles the frontend into
# src/dist, then cargo builds the Rust shell that embeds it. cargo-tauri.hook
# drives both: it replaces cargoBuildHook with `cargo tauri build`, which runs
# the beforeBuildCommand from tauri.conf.json - "npm run tauri:prebuild", the
# vite build - as part of its own build, then bundles. The hook asks for the deb
# bundle on Linux and installs that bundle's payload into $out, which is why
# nothing here has an explicit installPhase.
#
# Caveat: this build cannot flash, and that is upstream's gap rather than a
# packaging one. Tracking issue #4684 lists "added native serial support" as
# done and "Implement DFU" as still open; the native DFU plugin that exists,
# src-tauri/plugins/dfu, is Android only, on master too. DFU therefore still
# goes through WebUsbDfuTransport.js, which needs navigator.usb, and the webview
# here is WebKitGTK, which has no Web USB. checkCompatibility.js still passes the
# app because isTauri() short circuits the check, so it opens and serial works.
#
# The serial flashing protocol in webstm32.js is not a way around it. After the
# MSP_SET_REBOOT into the bootloader, handleDisconnect() waits for a DFU device
# via waitForDfu(), for both reboot modes, so a flash started from the serial
# port still ends at Web USB. Only no_reboot mode - the "No reboot sequence"
# option, for a board already held in its UART bootloader - stays on serial
# throughout.
#
# So flashing needs a Chromium engine: app.betaflight.com in a Chromium browser,
# with the udev rules in ../betaflight.nix. Worth knowing that the 10.10.0 in
# nixpkgs is not merely older - being NW.js, it is the last release with a
# Chromium engine, so it can flash where this cannot.
{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  nodejs,
  npmHooks,
  pkg-config,
  wrapGAppsHook3,
  glib-networking,
  librsvg,
  libsoup_3,
  openssl,
  udev,
  webkitgtk_4_1,
}:

let
  # The commit that tag 2026.6.1 points at. Pinned as a rev rather than a tag
  # so the short hash substituted into vite.config.js below is derived from the
  # very thing the source is fetched from, and cannot drift from it when the
  # version is bumped.
  rev = "14a057ffc58417c5128199fc1233284982a64be3";
in
rustPlatform.buildRustPackage rec {
  pname = "betaflight-configurator";
  version = "2026.6.1";

  src = fetchFromGitHub {
    owner = "betaflight";
    repo = "betaflight-configurator";
    inherit rev;
    hash = "sha256-5KS3nibbotoiJezJVKWcSpz8Bp5bd4rh20ZAoiPgAo8=";
  };

  # The crate is a subdirectory, so cargo needs pointing at it twice: cargoRoot
  # for where the lockfile to vendor lives, buildAndTestSubdir for where to run.
  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  # vite.config.js line 14 runs `git rev-parse --short HEAD` through execSync
  # with no fallback, only to define __APP_REVISION__ for the about screen.
  # fetchFromGitHub unpacks a tarball with no .git, so putting git in the build
  # would not help - it would fail as "not a git repository" instead of "git:
  # not found". Substituting the revision the tag points at keeps the value
  # truthful and the build independent of a repository being present.
  postPatch = ''
    substituteInPlace vite.config.js \
      --replace-fail 'child.execSync("git rev-parse --short HEAD").toString().trim()' '"${builtins.substring 0 7 rev}"'
  '';

  cargoHash = "sha256-jBchYNXiKpyURC2SCoy71Xv6b1jRwj6OvTxtcpZgKlA=";

  # package-lock.json pins Leaflet.MultiOptionsPolyline as a git+ssh dependency
  # rather than a registry tarball, and the npm fetcher refuses git dependencies
  # unless told that is expected, because they can carry install scripts and no
  # lockfile of their own.
  forceGitDeps = true;

  npmDeps = fetchNpmDeps {
    name = "${pname}-${version}-npm-deps";
    inherit src forceGitDeps;
    hash = "sha256-yMUCvL8PZfkkkRyDwLc/2lcqkg4zM2Dqa+H4lQozJHM=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    wrapGAppsHook3
  ];

  # scripts/check-tauri-prereqs.mjs is upstream's list of what this needs, and
  # it is the list below: webkit2gtk-4.1 and javascriptcoregtk-4.1 (both from
  # webkitgtk_4_1) for the webview, libsoup-3.0 for its HTTP stack, librsvg for
  # the icons the bundler rasterises, openssl, and libudev - from udev, which is
  # systemd's library split - for the serial port enumeration in
  # tauri-plugin-serialplugin. That script itself never runs here: it is wired
  # to the tauri:build npm script, and the hook calls `cargo tauri build`
  # directly. glib-networking is not in that list because it is a runtime need,
  # supplying the TLS backend GIO loads as a module; wrapGAppsHook3 puts it on
  # GIO_EXTRA_MODULES.
  buildInputs = [
    glib-networking
    librsvg
    libsoup_3
    openssl
    udev
    webkitgtk_4_1
  ];

  # npm otherwise refuses the store-owned cache with "Your cache folder contains
  # root-owned files".
  makeCacheWritable = true;

  # The Rust side has no tests, and cargo test would try to build the frontend
  # a second time.
  doCheck = false;

  preFixup = ''
    gappsWrapperArgs+=(
      # WebKit's compositing path renders a black or blank window under the
      # NVIDIA driver, which is what this machine runs. Same workaround the
      # other Tauri and Electron packages in nixpkgs carry.
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
    )
  '';

  meta = {
    description = "Configuration and management application for Betaflight flight controllers";
    homepage = "https://github.com/betaflight/betaflight-configurator";
    license = lib.licenses.gpl3Only;
    # Upstream's deb installs usr/bin/betaflight-app, so that is what the hook
    # moves into $out/bin - not the "Betaflight" productName, and not the
    # pname above.
    mainProgram = "betaflight-app";
    platforms = lib.platforms.linux;
  };
}
