{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = ["nvidia"];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia-container-toolkit.enable = true;

  systemd.services.nvidia-oc-manual = {
    description = "NVIDIA OC (Manual Binary)";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };

    environment = {
      LD_LIBRARY_PATH = "/run/opengl-driver/lib";
    };

    script = ''
      /root/nvidia_oc set \
        --index 0 \
        --power-limit 180000 \
        --freq-offset 150 \
        --mem-offset 2500

      /root/nvidia_oc set \
        --index 1 \
        --power-limit 180000 \
        --freq-offset 150 \
        --mem-offset 2500
    '';
  };
}