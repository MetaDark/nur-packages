{ lib
, stdenv
, rustPlatform
, fetchFromGitLab
, meson
, ninja
, pkg-config
, wrapGAppsHook
, gdk-pixbuf
, glib
, gtk3
, libhandy
, openssl
, sqlite
, webkitgtk
, glib-networking
, librsvg
, gst_all_1
}:

stdenv.mkDerivation rec {
  pname = "newsflash";
  version = "1.4.1";

  src = fetchFromGitLab {
    owner = "news-flash";
    repo = "news_flash_gtk";
    rev = version;
    hash = "sha256-pskmvztKOwutXRHVnW5u68/0DAuV9Gb+Ovp2JbXiMYo=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-qq8cZplt5YWUwsXUShMDhQm3RGH2kCEBk64x6bOa50E=";
  };

  # https://github.com/CasualX/obfstr/blob/v0.2.4/build.rs#L5
  # obfstr 0.2.4 fails to set RUSTC_BOOTSTRAP in its build script because cargo
  # build scripts are forbidden from setting RUSTC_BOOTSTRAP since rustc 1.52.0
  # https://github.com/rust-lang/rust/blob/1.52.0/RELEASES.md#compatibility-notes
  RUSTC_BOOTSTRAP = 1;

  patches = [
    # Post install tries to generate an icon cache & update the
    # desktop database. The gtk setup hook drop-icon-theme-cache.sh
    # would strip out the icon cache and the desktop database wouldn't
    # be included in $out. They will generated by xdg.mime.enable &
    # gtk.iconCache.enable instead.
    ./no-post-install.patch
  ];

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook

    # Provides setup hook to fix "Unrecognized image file format"
    gdk-pixbuf

    # Provides glib-compile-resources to compile gresources
    glib
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    gtk3
    libhandy
    openssl
    sqlite
    webkitgtk

    # TLS support for loading external content in webkitgtk WebView
    glib-networking

    # SVG support for gdk-pixbuf
    librsvg
  ] ++ (with gst_all_1; [
    # Audio & video support for webkitgtk WebView
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  meta = with lib; {
    description = "A modern feed reader designed for the GNOME desktop";
    homepage = "https://gitlab.com/news-flash/news_flash_gtk";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.all;
  };
}
