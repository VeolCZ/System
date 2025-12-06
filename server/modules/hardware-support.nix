{ config, pkgs, ... }:

{
  ########################################
  # NVIDIA GPU Support (optional)
  ########################################
  hardware.opengl.enable = true;

  # Uncomment for NVIDIA machines:
  #
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = false;
  #   open = false; # enable open-source kernel driver
  # };
}
