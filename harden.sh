#!/usr/bin/env bash
# Harden Ubuntu: UFW + Fail2Ban + Unattended Upgrades + Tailscale support

set -euo pipefail

TS_UDP_PORT="${TS_UDP_PORT:-41641}"   # optional inbound UDP port

require_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "Please run as root (e.g., sudo $0)"; exit 1
  fi
}

apt_install() {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -y
  apt-get install -y ufw fail2ban unattended-upgrades
}

detect_ssh_port() {
  local port=""
  if command -v sshd >/dev/null 2>&1; then
    port="$(sshd -T 2>/dev/null | awk '/^port /{print $2; exit}' || true)"
  fi
  echo "${port:-22}"
}

has_tailscale_iface() {
  ip link show tailscale0 >/dev/null 2>&1
}

configure_ufw() {
  local ssh_port="$1"

  ufw --force reset
  ufw default deny incoming
  ufw default allow outgoing

  # Public SSH rule
  if [[ "$ssh_port" == "22" ]]; then
    ufw allow OpenSSH
  else
    ufw allow "${ssh_port}/tcp"
  fi

  # Allow all traffic on tailscale0
  if has_tailscale_iface; then
    ufw allow in on tailscale0
  fi

  # Allow inbound UDP 41641 on public for better P2P
  ufw allow "${TS_UDP_PORT}"/udp

  ufw --force enable
  ufw reload
}

configure_fail2ban() {
  install -d -m 0755 /etc/fail2ban/jail.d
  cat >/etc/fail2ban/jail.d/sshd.local <<'EOF'
[sshd]
enabled = true
port = ssh
backend = systemd
bantime = 1h
findtime = 10m
maxretry = 5
ignoreip = 127.0.0.1/8 ::1
EOF
  systemctl enable fail2ban
  systemctl restart fail2ban
  fail2ban-client status sshd || true
}

configure_unattended_upgrades() {
  systemctl enable unattended-upgrades
  systemctl restart unattended-upgrades || true
  cat >/etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
EOF
  awk '
    BEGIN {
      print "Unattended-Upgrade::Automatic-Reboot \"true\";";
      print "Unattended-Upgrade::Automatic-Reboot-Time \"02:00\";";
    }' >/etc/apt/apt.conf.d/51unattended-upgrades-local
  unattended-upgrade -d || true
}

main() {
  require_root
  apt_install
  SSH_PORT="$(detect_ssh_port)"
  echo "Detected SSH port: ${SSH_PORT}"
  configure_ufw "$SSH_PORT"
  configure_fail2ban
  configure_unattended_upgrades

  echo "✅ Hardening complete."
  echo "• UFW: inbound denied, outbound allowed."
  echo "• SSH: ${SSH_PORT}/tcp allowed publicly, plus tailnet access via tailscale0."
  echo "• Fail2Ban: sshd jail enabled."
  echo "• Unattended upgrades: enabled with daily checks and auto-reboot at 02:00 if needed."
}

main "$@"
