{ stdenv, fetchurl, dpkg }:

stdenv.mkDerivation rec {
  pname = "runescape-launcher";
  version = "2.2.6";

  # Debian Repo:
  # curl https://content.runescape.com/downloads/ubuntu/dists/trusty/Release
  # curl https://content.runescape.com/downloads/ubuntu/dists/trusty/non-free/binary-amd64/Packages
  src = fetchurl {
    url = "https://content.runescape.com/downloads/ubuntu/pool/non-free/r/${pname}/${pname}_${version}_amd64.deb";
    sha256 = "1j8w1ydpldnjv9ljwqgpv9hm4x9qkc5sslmarp4r2rpimvd5n9h8";
  };

  nativeBuildInputs = [ dpkg ];
  unpackPhase = "dpkg-deb -x $src .";
  installPhase = ''
    mkdir -p "$out"
    cp -r usr/* "$out"
  '';

  # Avoid modifying the executable to comply with the license
  dontPatchELF = true;
  dontStrip = true;

  postFixup = ''
    substituteInPlace "$out/bin/${pname}" \
      --replace /usr/share/games/${pname} "$out/share/games/${pname}"

    substituteInPlace "$out/share/applications/${pname}.desktop" \
      --replace /usr/bin/${pname} ${pname}
  '';

  meta = with stdenv.lib; {
    description = "RuneScape Game Client (NXT)";
    homepage = https://www.runescape.com/;
    maintainers = with maintainers; [ metadark ];
    license = {
      fullName = "RuneScape EULA";
      url = http://content.runescape.com/downloads/LICENCE.txt;
      free = false;
    };
    platforms = [ "x86_64-linux" ];
  };
}