{ lib, pkgs }:

(
  let awsSamTranslator = pkgs.python37Packages.buildPythonPackage rec {
    pname = "aws-sam-translator";
    version = "1.32.0";

    src = pkgs.python37Packages.fetchPypi {
      inherit pname version;
      sha256 = "1bjnkl6i6ddj6a88yapzn08qz1l03jq42mg284sp0ycva81argwc";
    };

    # Tests are not included in the PyPI package
    doCheck = false;

    propagatedBuildInputs = [
      pkgs.python37Packages.boto3
      pkgs.python37Packages.jsonschema
      pkgs.python37Packages.six
    ];

    meta = with lib; {
      homepage = "https://github.com/awslabs/serverless-application-model";
      description = "Python library to transform SAM templates into AWS CloudFormation templates";
      license = licenses.asl20;
      maintainers = with maintainers; [ andreabedini ];
    };
  };

in 
  pkgs.python37Packages.buildPythonApplication rec {
    pname =  "aws-sam-cli";
    version = "1.13.1";

    src = pkgs.python37Packages.fetchPypi {
      inherit pname version;
      sha256 = "0s2bxbf3j4mlxmmcjjmfplixpp5khxxgkhd96bb1s09l1l3mc2il";
    };

    propagatedBuildInputs = [
      pkgs.python37Packages.aws-lambda-builders
      #pkgs.python37Packages.aws-sam-translator
      awsSamTranslator
      pkgs.python37Packages.chevron
      pkgs.python37Packages.click
      pkgs.python37Packages.cookiecutter
      pkgs.python37Packages.dateparser
      pkgs.python37Packages.python-dateutil
      pkgs.python37Packages.docker
      pkgs.python37Packages.flask
      pkgs.python37Packages.jmespath
      pkgs.python37Packages.requests
      pkgs.python37Packages.serverlessrepo
      pkgs.python37Packages.tomlkit
    ];

    # fix over-restrictive version bounds
    postPatch = ''
      substituteInPlace requirements/base.txt \
	--replace "boto3~=1.14.23" "boto3~=1.14" \
	--replace "docker~=4.2.0" "docker~=4.3.1" \
	--replace "python-dateutil~=2.6, <2.8.1" "python-dateutil~=2.6" \
	--replace "requests==2.23.0" "requests~=2.24" \
	--replace "serverlessrepo==0.1.9" "serverlessrepo~=0.1.9"
    '';

    doCheck = false;

    postFixup = ''
      mkdir -p $out/bin
      wrapProgram $out/bin/sam --set SAM_CLI_TELEMETRY 0
    '';

    meta = with lib; {
      homepage = "https://github.com/aws/aws-sam-cli";
      description = "CLI tool to build, test, debug, and deploy Serverless applications using AWS SAM";
      license = licenses.asl20;
      maintainers = with maintainers; [ aws ];
    };
  }
)
