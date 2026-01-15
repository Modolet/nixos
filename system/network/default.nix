{ pkgs, ... }:
{
  networking = {
    nameservers = [
      "114.114.114.114"
      "114.114.115.115"
      "8.8.8.8"
      "8.8.4.4"
    ];

    nftables.enable = true;

    networkmanager = {
      enable = true;
      dns = "none";
      wifi.powersave = true;
      # plugins = with pkgs; [
      #   networkmanager-openvpn
      # ];
    };

    useDHCP = false;
    dhcpcd.enable = false;
  };

  services = {
    openssh = {
      enable = true;
      settings.UseDns = true;
    };
  };

  # Don't wait for network startup
  systemd.services.NetworkManager-wait-online.serviceConfig.ExecStart = [
    ""
    "${pkgs.networkmanager}/bin/nm-online -q"
  ];
  environment.etc.hosts.enable = false;
}
