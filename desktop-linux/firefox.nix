{ ... }:

{
  programs.firefox = {
    enable = true;

    # "locked" is the module default. It matters here for two reasons: a locked
    # value beats anything already set in an existing profile, so these apply to
    # the profile that is already on disk, and nothing can switch them back by
    # accident. The cost is that the matching controls in about:preferences are
    # greyed out with an "organization" note. Set to "default" to make them
    # apply as defaults that stay changeable in the UI.
    preferencesStatus = "locked";

    # Verified against the defaults in firefox-154.0: the pref names below all
    # appear in its greprefs.js / firefox.js, and "browser." and
    # "keyword.enabled" are both on the Preferences policy's allowed-prefix list
    # (see modules/policies/Policies.sys.mjs).
    preferences = {
      # Nothing typed in the address bar should reach the network before Enter
      # is pressed. The remaining suggestion sources (history, bookmarks, open
      # tabs) are local and never leave the machine, so they stay on.
      "browser.search.suggest.enabled" = false;
      "browser.urlbar.suggest.searches" = false;
      "browser.urlbar.suggest.trending" = false;
      "browser.urlbar.trending.featureGate" = false;
      "browser.urlbar.suggest.recentsearches" = false;

      # Firefox Suggest, Mozilla's own suggestion service.
      "browser.urlbar.quicksuggest.enabled" = false;
      "browser.urlbar.suggest.quicksuggest.sponsored" = false;
      "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;

      # Suggest's individual verticals. These are what turn "test" into a book
      # title: each is a separate lookup against a remote source, and switching
      # off the parent pref above does not reliably switch them off too.
      "browser.urlbar.suggest.amp" = false;
      "browser.urlbar.suggest.wikipedia" = false;
      "browser.urlbar.suggest.weather" = false;
      "browser.urlbar.suggest.sports" = false;
      "browser.urlbar.suggest.yelp" = false;
      "browser.urlbar.suggest.yelpRealtime" = false;
      "browser.urlbar.suggest.mdn" = false;
      "browser.urlbar.suggest.addons" = false;
      "browser.urlbar.suggest.importantDates" = false;

      # Without this Firefox opens a connection to the highlighted row before it
      # is picked, which discloses the guess even when the guess is wrong.
      "browser.urlbar.speculativeConnect.enabled" = false;

      # Deliberately true: this is the switch that decides whether a non-URL in
      # the address bar searches at all. Enter should still search.
      "keyword.enabled" = true;

      # The home page's own telemetry ping, separate from DisableTelemetry.
      "browser.newtabpage.activity-stream.telemetry" = false;
    };

    policies = {
      # Matched with getEngineByName, so this is the display name rather than
      # the "ddg" identifier. Firefox only reapplies this when the value itself
      # changes, so switching engine later in the UI will not be reverted.
      SearchEngines.Default = "DuckDuckGo";

      # Covers the suggestion path that does not go through the urlbar prefs.
      SearchSuggestEnabled = false;

      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
      };

      # The home page, via policy rather than prefs: FirefoxHome sets the
      # underlying activity-stream prefs itself, including the two separate
      # weather prefs the current layout needs.
      FirefoxHome = {
        Search = true;
        TopSites = true; # Built from local history, so nothing is fetched.
        SponsoredTopSites = false;
        Weather = false;
        Stories = false;
        SponsoredStories = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
      };

      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;

      # Mozilla's in-product messaging: recommendation banners, the What's New
      # panel, and the address bar "interventions" that offer to clear a cache
      # or update the browser as you type.
      UserMessaging = {
        WhatsNew = false;
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        MoreFromMozilla = false;
        SkipOnboarding = true;
      };
    };
  };

  # Make xdg-open (and so anything that shells out to it) pick Firefox. These
  # are the MIME types firefox.desktop declares.
  xdg.mime.defaultApplications = {
    "text/html" = "firefox.desktop";
    "text/xml" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
    "application/vnd.mozilla.xul+xml" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
  };

  # For CLI tools that read $BROWSER directly rather than going via xdg-open.
  environment.variables.BROWSER = "firefox";
}
