{ config, pkgs, ... }:

{
  ########################################
  # SSH
  ########################################
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = true;
    ports = [ 22 ];
    
    # Remove weak ciphers and algorithms
    settings.KbdInteractiveAuthentication = false;
    settings.X11Forwarding = false;
    settings.KexAlgorithms = [
      "curve25519-sha256"
      "curve25519-sha256@libssh.org"
      "diffie-hellman-group16-sha512"
      "diffie-hellman-group18-sha512"
      "sntrup761x25519-sha512@openssh.com"
    ];
  };

  # Allow SSH port in firewall
  networking.firewall.allowedTCPPorts = [ 22 ];
}
