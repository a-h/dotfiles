# Create the standard environment.
source $stdenv/setup
# Extract the source code.
tar xvfz $src
# Create place to store the binaries.
mkdir -p $out/bin
# Copy the src directory to the output binary directory.
cp -r adr-tools-3.0.0/src/* $out/bin
