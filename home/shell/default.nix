{
  pkgs,
  ...
}:

{
  programs = {
    nushell = {
      enable = true;
      package = pkgs.nushell;
      extraConfig =
        let
          conf = builtins.toJSON {
            show_banner = false;
          };
        in
        ''
          $env.config = ${conf};
        '';
    };

    starship = {
      enable = true;
      enableNushellIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableNushellIntegration = true;
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
  };

  stylix.targets.nushell.enable = true;
  stylix.targets.starship.enable = true;
}
