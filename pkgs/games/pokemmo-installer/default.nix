{ lib
, stdenv
, fetchFromGitLab
, makeWrapper
, coreutils
, findutils
, gnugrep
, jre
, openssl
, ps
, wget
, which
, xprop
, zenity
, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "pokemmo-installer";
  version = "1.4.7";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "games-team";
    repo = pname;
    rev = version;
    sha256 = "13i50y1d97inbnp4wdnm9b4chijfjwd3lgk8yb9spjp9hy880kc3";
  };

  nativeBuildInputs = [ makeWrapper ];

  installFlags = [
    "PREFIX=${placeholder "out"}"

    # BINDIR defaults to $(PREFIX)/games
    "BINDIR=${placeholder "out"}/bin"
  ];

  postFixup = ''
    wrapProgram "$out/bin/${pname}" \
      --prefix PATH : ${lib.makeBinPath [
        coreutils
        findutils
        gnugrep
        jre
        openssl
        ps
        wget
        which
        xprop
        zenity
      ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        libpulseaudio
      ]}
  '';

  meta = with stdenv.lib; {
    description = "Installer and Launcher for the PokeMMO emulator";
    homepage = "https://pokemmo.eu";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ metadark ];
    platforms = platforms.linux;
  };
}
