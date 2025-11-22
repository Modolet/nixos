{ pkgs, helpers }:

let inherit (helpers) mkCategoryExtra;
in {
  vscode = {
    vscode = mkCategoryExtra "vscode" {
      name = "";
      importPath = "lazyvim.plugins.extras.vscode";
    };
  };
}

