final: prev: {
  apple-fonts = prev.callPackage ./Apple-Fonts { };
  wallpapers = prev.callPackage ./wallpapers.nix { };
  maple-mono-variable = prev.callPackage ./maple-mono-variable.nix { };
}
