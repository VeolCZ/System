{ config, pkgs, ... }:

{
  ########################################
  # Fail2Ban
  ########################################
  services.fail2ban = {
    enable = true;
    maxretry = 5;

    jails = {
      sshd = ''
        enabled = true
        port = ssh
        backend = systemd
        bantime = 1h
        findtime = 10m
        maxretry = 5
        ignoreip = 127.0.0.1/8 ::1
      '';
    };
  };
}
