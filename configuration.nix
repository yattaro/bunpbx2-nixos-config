let
  secrets = import ./secrets.nix {};
  asterisk-configuration = import ./asterisk-configuration.nix {};
in
{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.package = pkgs.lix;

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking = {
    hostName = "bunpbx2";
  };

  time.timeZone = "America/New_York";
  services.timesyncd.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = false;

  services.openssh = {
	enable = true;
	settings.PermitRootLogin = "no";
  };

  users.users.yattaro = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    vim
    wget
    tmux
  ];

  services.asterisk = {
    enable = true;
    confFiles = {
      "extensions.conf" = ${asterisk-configuration.asterisk.extensions_conf};
      "pjsip.conf" = ${asterisk-configuration.asterisk.extensions_conf};
    };
  };

  system.stateVersion = "24.11";

}
