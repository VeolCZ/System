{ config, pkgs, ... }:

{
  ########################################
  # Fail2Ban
  ########################################
  services.fail2ban = {
    enable = true;
    jails = {
      sshd = ''
        enabled = true
        port = ssh
        backend = systemd
        bantime = 1h
        findtime = 10m
        maxretry = 5
      '';
    };
  };
}
