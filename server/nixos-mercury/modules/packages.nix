{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    htop
    nvtopPackages.full
    cudaPackages.cudatoolkit
  ];

  services.cron.enable = false;
}
