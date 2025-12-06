{ config, pkgs, ... }:

{
  ########################################
  # Tailscale
  ########################################
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  environment.systemPackages = [ pkgs.tailscale ];

  networking.firewall = {
    # Tailscale hole punching
    allowedUDPPorts = [ 41641 ];

    # Trust tailnet
    trustedInterfaces = [ "tailscale0" ];
  };
}
