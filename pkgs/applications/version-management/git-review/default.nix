{ lib
, fetchurl
, buildPythonApplication
, pbr
, requests
, setuptools
}:

buildPythonApplication rec {
  pname = "git-review";
  version = "2.0.0";

  # Manually set version because prb wants to get it from the git
  # upstream repository (and we are installing from tarball instead)
  PBR_VERSION = version;

  src = fetchurl {
    url = "https://opendev.org/opendev/${pname}/archive/${version}.tar.gz";
    hash = "sha256-0koFKlYDd+KAylZyA5iJcMRZcWps6EhCUHrXLl5pfjY=";
  };

  propagatedBuildInputs = [
    pbr
    requests
    setuptools # implicit dependency, used to get package version through pkg_resources
  ];

  # Don't run tests because they pull in external dependencies
  # (a specific build of gerrit + maven plugins), and I haven't figured
  # out how to work around this yet.
  doCheck = false;

  meta = with lib; {
    description = "Tool to submit code to Gerrit";
    homepage = "https://opendev.org/opendev/git-review";
    license = licenses.asl20;
    maintainers = with maintainers; [ metadark ];
  };
}
