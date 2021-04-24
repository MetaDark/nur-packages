{ lib
, pkgs
, nodejs
, stdenv
, linkFarm
, fetchzip
, buildPythonPackage
, fetchFromGitHub
, nltk
, mock
, pytestCheckHook
}:

let
  acceptance_tests = (import ./acceptance_tests/node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  }).package;

  nltk_data_rev = "3a486db7729373e7982eda3f7e6e6572c532d06c";
  nltk_data = linkFarm "nltk_data" [
    {
      name = "corpora/stopwords";
      path = fetchzip {
        url = "https://github.com/nltk/nltk_data/raw/${nltk_data_rev}/packages/corpora/stopwords.zip";
        hash = "sha256-jLT1SW8gdawWgwMlrQ3bYaRfHhbYp0beKowKJ5WJfyI=";
      };
    }
  ];
in buildPythonPackage rec {
  pname = "lunr.py";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "yeraydiazdiaz";
    repo = pname;
    rev = version;
    hash = "sha256-u2nZ8majUejdhBQ43ptOOzBr3f00O5MM+1IUp3AAOqk=";
  };

  patches = [
    ./loosen-requirements.patch
  ];

  propagatedBuildInputs = [
    nltk
  ];

  checkInputs = [
    mock
    nodejs
    pytestCheckHook
  ];

  # Patch in node_modules & nltk_data for tests
  preCheck = ''
    ln -s ${acceptance_tests}/lib/node_modules/acceptance_tests/node_modules tests/acceptance_tests/javascript
    export NLTK_DATA=${nltk_data}
  '';

  pythonImportsCheck = [ "lunr" ];

  meta = with lib; {
    description = "A Python implementation of Lunr.js";
    homepage = "https://github.com/yeraydiazdiaz/lunr.py";
    license = licenses.mit;
    maintainers = with maintainers; [ metadark ];
  };
}
