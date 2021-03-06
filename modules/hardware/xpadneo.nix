{ config, lib, pkgs, ... }:

with lib;
let
  nur = import ../.. { inherit pkgs; };
  cfg = config.hardware.xpadneo;
in
{
  options.hardware.xpadneo = {
    enable = mkEnableOption "the xpadneo driver for Xbox One wireless controllers";
  };

  config = mkIf cfg.enable {
    boot = {
      # Must disable Enhanced Retransmission Mode to support bluetooth pairing
      # https://wiki.archlinux.org/index.php/Gamepad#Connect_Xbox_Wireless_Controller_with_Bluetooth
      extraModprobeConfig =
        mkIf
          config.hardware.bluetooth.enable
          "options bluetooth disable_ertm=1";

      extraModulePackages = [
        (nur.xpadneo.override {
          inherit (config.boot.kernelPackages) kernel;
        })
      ];
      kernelModules = [ "hid_xpadneo" ];
    };
  };

  meta = {
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
