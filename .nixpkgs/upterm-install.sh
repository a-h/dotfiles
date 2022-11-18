# Create the standard environment.
source $stdenv/setup
# Create output directories.
mkdir -p $out/bin
# Go requires a cache directory so let's point it at one.
mkdir go-cache
export GOCACHE=/tmp/go-cache
# Build and write directly to bin.
cd $src/cmd/upterm
go build -o $out/bin/upterm
