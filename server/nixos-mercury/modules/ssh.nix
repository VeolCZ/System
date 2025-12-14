{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;

      # VERY IMPORTANT for VS Code:
      Subsystem = "sftp ${pkgs.openssh}/libexec/sftp-server";

      KexAlgorithms = [
        "sntrup761x25519-sha512@openssh.com"
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group14-sha256"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
      ];

      ListenAddress = "0.0.0.0";
    };

    ports = [ 22 ];
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
}
