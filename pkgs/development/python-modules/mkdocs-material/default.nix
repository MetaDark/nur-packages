{ lib
, buildPythonPackage
, fetchFromGitHub
, markdown
, mkdocs
, pygments
, pymdown-extensions
, mkdocs-material-extensions
}:

buildPythonPackage rec {
  pname = "mkdocs-material";
  version = "6.1.5";

  src = fetchFromGitHub {
    owner = "squidfunk";
    repo = pname;
    rev = version;
    sha256 = "1hvblld4wkz1hhk9i1lvxs536frv2r0gv1lgfg4k9ivyji66rih2";
  };

  patches = lib.optional (mkdocs-material-extensions == null)
    ./remove-circular-dependency.patch;

  propagatedBuildInputs = [
    markdown
    mkdocs
    pygments
    pymdown-extensions
  ] ++ lib.optional (mkdocs-material-extensions != null) mkdocs-material-extensions;

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "A Material Design theme for MkDocs";
    homepage = "https://squidfunk.github.io/mkdocs-material";
    license = licenses.mit;
    maintainers = with maintainers; [ metadark ];
  };
}
