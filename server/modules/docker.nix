{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
    liveRestore = true;
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
