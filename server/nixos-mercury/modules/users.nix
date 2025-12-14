{ config, pkgs, ... }:

{
  users.users.veol = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.bashInteractive;
    # Set password manually: sudo passwd veol
    initialPassword = "password";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINfgC8MkCesCgGjGoH1cbA8Fegg44Ak55Zx78BShfiI1 jakub.gembler@gmail.com"
    ];
  };
}
