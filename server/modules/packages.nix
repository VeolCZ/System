{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # vscode
    git
    htop
    # nvtop
  ];

  services.cron.enable = false;
}
