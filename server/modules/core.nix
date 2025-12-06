{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "server";
  time.timeZone = "CET";


  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "03:00";
    channel = "https://channels.nixos.org/nixos-24.05";
  };


  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.05";
}
