{ pkgs, helpers }:

let inherit (helpers) mkCategoryExtra withPkgs;
in {
  linting = {
    eslint = mkCategoryExtra "linting" {
      name = "eslint";
      lspServers = withPkgs [ "eslint" ];
    };
  };
}

