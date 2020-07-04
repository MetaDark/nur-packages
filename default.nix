# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> {} }:

rec {
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  caprine = pkgs.callPackage ./pkgs/applications/networking/instant-messengers/caprine {
    electron = pkgs.electron_9;
  };

  clonehero-unwrapped = pkgs.callPackage ./pkgs/games/clonehero {};

  clonehero-xdg-wrapper = pkgs.callPackage ./pkgs/games/clonehero/xdg-wrapper.nix {
    inherit clonehero-unwrapped;
  };

  clonehero-fhs-wrapper = pkgs.callPackage ./pkgs/games/clonehero/fhs-wrapper.nix {
    inherit clonehero-unwrapped clonehero-xdg-wrapper;
  };

  clonehero = clonehero-fhs-wrapper;

  cmake-language-server = pkgs.python3Packages.callPackage ./pkgs/development/tools/misc/cmake-language-server {
    inherit pygls;
  };

  debugpy = pkgs.python3Packages.callPackage ./pkgs/development/python-modules/debugpy {};

  lightdm-webkit2-greeter = pkgs.callPackage ./pkgs/applications/display-managers/lightdm-webkit2-greeter {
    inherit lightdm-webkit2-greeter;
  };

  pygls = pkgs.python3Packages.callPackage ./pkgs/development/python-modules/pygls {};

  runescape-launcher = pkgs.callPackage ./pkgs/games/runescape-launcher/wrapper.nix {};

  texlab = pkgs.callPackage ./pkgs/development/tools/misc/texlab {
    inherit (pkgs.darwin.apple_sdk.frameworks) Security;
  };

  VVVVVV-unwrapped = pkgs.callPackage ./pkgs/games/VVVVVV/default.nix {
    inherit (pkgs.darwin.apple_sdk.frameworks) Foundation;
  };

  VVVVVV = pkgs.callPackage ./pkgs/games/VVVVVV/wrapper.nix {
    inherit (pkgs.darwin.apple_sdk.frameworks) Foundation;
  };

  zynaddsubfx = zynaddsubfx-ntk;

  zynaddsubfx-fltk = pkgs.callPackage ./pkgs/applications/audio/zynaddsubfx {
    guiModule = "fltk";
  };

  zynaddsubfx-ntk = pkgs.callPackage ./pkgs/applications/audio/zynaddsubfx {
    guiModule = "ntk";
  };

  zyn-fusion = pkgs.callPackage ./pkgs/applications/audio/zynaddsubfx {
    guiModule = "zest";
  };
}
