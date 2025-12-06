{ config, pkgs, ... }:

{
  ########################################
  # Security (Firewall & Kernel)
  ########################################
  networking.firewall.enable = true;

  # AppArmor (Mandatory Access Control)
  security.apparmor.enable = true;
  
  # Auditd (Security Auditing)
  security.audit.enable = true;
  security.auditd.enable = true;

  # Sudo: Only allow members of the wheel group to execute sudo
  security.sudo.execWheelOnly = true;

  ########################################
  # Hardened Kernel & Sysctl (safe defaults)
  ########################################
  boot.kernel.sysctl = {
    # Network hardening
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    
    # Ignore ICMP bogon error messages
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    
    # Do not accept ICMP redirects (prevent MITM attacks)
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    
    # Turn on Source Address Verification in all interfaces to
    # prevent some spoofing attacks
    "net.ipv4.conf.all.log_martians" = 1;
    
    # Restrict kernel logs (dmesg) to root
    "kernel.dmesg_restrict" = 1;
    
    # Hide kernel pointers from unprivileged users
    "kernel.kptr_restrict" = 2;
  };
  
  # Disable core dumps (prevents sensitive data leaks)
  systemd.coredump.enable = false;
}
