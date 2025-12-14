{ config, pkgs, ... }:

{
  networking.hostName = "mercury";

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
  programs.nix-ld.enable = true;
  environment.shells = [ pkgs.bashInteractive ];
  environment.systemPackages = [ pkgs.bashInteractive ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
