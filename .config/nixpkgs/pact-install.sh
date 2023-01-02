# Create the standard environment.
source $stdenv/setup
# Extract the source code.
tar xvfz $src
# Store the libraries and extracted code.
mkdir -p $out/opt/pact
# Create place to store the binaries.
mkdir -p $out/bin
# Copy the pact/bin directory to the output binary directory.
cp -r pact $out/opt/
# Make symlinks to the binaries.
ln -s $out/opt/pact/bin/pact $out/bin/pact
ln -s $out/opt/pact/bin/pact-broker $out/bin/pact-broker
ln -s $out/opt/pact/bin/pact-message $out/bin/pact-message
ln -s $out/opt/pact/bin/pact-mock-service $out/bin/pact-mock-service
ln -s $out/opt/pact/bin/pact-provider-verifier $out/bin/pact-provider-verifier
ln -s $out/opt/pact/bin/pact-publish $out/bin/pact-publish
ln -s $out/opt/pact/bin/pact-stub-service $out/bin/pact-stub-service
