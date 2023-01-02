# Create the standard environment.
source $stdenv/setup
# Extract the source code.
tar xvfz $src
# Store the libraries and extracted code.
mkdir -p $out/opt/jdtls
# Create place to store the binaries.
mkdir -p $out/bin
# Put output in the jdtls directory.
cp -r * $out/opt/jdtls/
# Create the startup script..
cat << EOF > $out/bin/jdtls
#!/bin/bash
mkdir -p ~/jdtls/data
cp -r $out/opt/jdtls/* ~/jdtls
chmod 770 ~/jdtls/*
java \
        -Declipse.application=org.eclipse.jdt.ls.core.id1 \
        -Dosgi.bundles.defaultStartLevel=4 \
        -Declipse.product=org.eclipse.jdt.ls.core.product \
        -Dlog.level=ERROR \
        -noverify \
        -Xmx1G \
        -jar $out/opt/jdtls/plugins/org.eclipse.equinox.launcher_1.6.300.v20210813-1054.jar \
        -configuration ~/jdtls/config_mac \ 
        -data ~/jdtls/data \
        --add-modules=ALL-SYSTEM \
        --add-opens java.base/java.util=ALL-UNNAMED \
        --add-opens java.base/java.lang=ALL-UNNAMED
EOF
chmod +x $out/bin/jdtls
