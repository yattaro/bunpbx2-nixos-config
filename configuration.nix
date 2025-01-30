let
  asterisk-configuration = import ./asterisk-configuration.nix;
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
    firewall.allowedUDPPorts = [
      5060
    ];
  };

  time.timeZone = "America/New_York";
  services.timesyncd.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

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
    git
  ];

  services.asterisk = {
    enable = true;
    confFiles = {
      "extensions.conf" = ''
        ${asterisk-configuration.asterisk.extensions_conf}
      '';
      "pjsip.conf" = ''
        ${asterisk-configuration.asterisk.pjsip_conf}
      '';
      "logger.conf" = ''
        ${asterisk-configuration.asterisk.logger_conf}
      '';
    };
    useTheseDefaultConfFiles = [
      "ari.conf"
      "acl.conf"
      "agents.conf"
      "amd.conf"
      "calendar.conf"
      "cdr.conf"
      "cdr_syslog.conf"
      "cdr_custom.conf"
      "cel.conf"
      "cli_aliases.conf"
      "confbridge.conf"
      "dundi.conf"
      "features.conf"
      "heap.conf"
      "iax.conf"
      "pjsip.conf"
      "pjsip_wizard.conf"
      "phone.conf"
      "phoneprov.conf"
      "queues.conf"
      "res_config_sqlite3.conf"
      "res_parking.conf"
      "statsd.conf"
      "udptl.conf"
      "unistim.conf"
      "adsi.conf"
      "alarmreceiver.conf"
      "ast_debug_tools.conf"
      "asterisk.adsi"
      "aeap.conf"
      "ccss.conf"
      "cdr_beanstalkd.conf"
      "cli.conf"
      "cli_permissions.conf"
      "codecs.conf"
      "enum.conf"
      "extconfig.conf"
      "followme.conf"
      "http.conf"
      "indications.conf"
      "logger.conf"
      "manager.conf"
      "modules.conf"
      "musiconhold.conf"
      "muted.conf"
      "osp.conf"
      "phoneprov.conf"
      "pjproject.conf"
      "pjsip_notify.conf"
      "prometheus.conf"
      "queuerules.conf"
      "resolver_unbound.conf"
      "res_stun_monitor.conf"
      "rtp.conf"
      "say.conf"
      "sla.conf"
      "smdi.conf"
      "sorcery.conf"
      "stasis.conf"
      "stir_shaken.conf"
      "users.conf"
      "vpb.conf"
    ];
  };

  system.stateVersion = "24.11";

}

