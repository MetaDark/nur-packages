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

  clonehero-unwrapped = pkgs.callPackage ./pkgs/games/clonehero { };

  clonehero-xdg-wrapper = pkgs.callPackage ./pkgs/games/clonehero/xdg-wrapper.nix {
    inherit clonehero-unwrapped;
  };

  clonehero-fhs-wrapper = pkgs.callPackage ./pkgs/games/clonehero/fhs-wrapper.nix {
    inherit clonehero-unwrapped clonehero-xdg-wrapper;
  };

  clonehero = clonehero-fhs-wrapper;

  lightdm-webkit2-greeter = pkgs.callPackage ./pkgs/applications/display-managers/lightdm-webkit2-greeter {
    inherit lightdm-webkit2-greeter;
  };

  vvvvvv = pkgs.callPackage ./pkgs/games/vvvvvv/wrapper.nix {
    inherit (pkgs.darwin.apple_sdk.frameworks) Foundation;
  };
}
