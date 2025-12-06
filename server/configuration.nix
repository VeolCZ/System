{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/core.nix
    ./modules/users.nix
    ./modules/ssh.nix
    ./modules/fail2ban.nix
    ./modules/docker.nix
    ./modules/tailscale.nix
    ./modules/security.nix
    ./modules/packages.nix
    ./modules/hardware-support.nix
  ];
}