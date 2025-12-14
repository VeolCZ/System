{ config, pkgs, lib, ... }:

{
  services.fail2ban = {
    enable = true;
    jails = {
      sshd = lib.mkForce ''
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