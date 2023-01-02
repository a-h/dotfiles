# Global node packages

This directory contains Node.js packages that are installed globally, e.g. AWS Amplify SDK, that aren't already available in nixpkgs.

The `node-packages.json` file contains an array of all the packages to make available.

To update the nix expression run:

```
node2nix -i node-packages.json
```

