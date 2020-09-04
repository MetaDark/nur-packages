{ stdenv
, fetchFromGitLab
, docbook_xml_dtd_43
, docbook_xsl
, gobject-introspection
, gtk-doc
, meson
, ninja
, pkgconfig
, vala
, glade
, gtk3
, librsvg
, libxml2
, dbus
, xvfb_run
, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "libhandy1";
  version = "0.91.0";

  outputs = [ "out" "dev" "devdoc" "glade" ];
  outputBin = "dev";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libhandy";
    rev = version;
    sha256 = "0b8z1x0g7d64g5p1yjhmr3n304kbw4x1qbcn03ag0ffgaidw8w3f";
  };

  nativeBuildInputs = [
    docbook_xml_dtd_43
    docbook_xsl
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [ glade gtk3 libxml2 ];
  checkInputs = [ dbus librsvg xvfb_run ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dglade_catalog=enabled"
    "-Dintrospection=enabled"
  ];

  PKG_CONFIG_GLADEUI_2_0_MODULEDIR = "${placeholder "glade"}/lib/glade/modules";
  PKG_CONFIG_GLADEUI_2_0_CATALOGDIR = "${placeholder "glade"}/share/glade/catalogs";

  doCheck = true;

  checkPhase = ''
    NO_AT_BRIDGE=1 \
    XDG_DATA_DIRS="$XDG_DATA_DIRS:${hicolor-icon-theme}/share" \
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      meson test --print-errorlogs
  '';

  meta = with stdenv.lib; {
    description = "Building blocks for modern adaptive GNOME apps";
    homepage = "https://gitlab.gnome.org/GNOME/libhandy";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar metadark ];
    platforms = platforms.linux;
  };
}
