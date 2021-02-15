{ lib
, buildPythonPackage
, fetchFromGitHub
, pyyaml
}:

buildPythonPackage rec {
  pname = "aamp";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "zeldamods";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cmn2THRhGWebqNPakMT25Lahzwm822DKMYh5Kgn7Pmw=";
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  checkPhase = ''
    export PATH=$out/bin:$PATH
    python test.py
  '';

  meta = with lib; {
    description = "Nintendo parameter archive (AAMP) library and converters";
    homepage = "https://github.com/zeldamods/aamp";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ metadark ];
  };
}
