# Create the standard environment.
source $stdenv/setup
# Create output directories.
mkdir -p $out/bin
# Go requires a cache directory so let's point it at one.
mkdir $TMPDIR/go-cache
GOCACHE=$TMPDIR/go-cache
GOMODCACHE=$TMPDIR/go-cache
export GOCACHE
export GOMODCACHE
export GOPROXY=direct
# Build and write directly to bin.
cd $src/cmd/xc
go build -o $out/bin/xc
