{ stdenvNoCC, fetchurl }:
let
  wallpapers = [
    {
      name = "frieren-butterflies.jpg";
      src = fetchurl {
        url = "https://i.imgur.com/H1noDhu.jpg";
        sha256 = "0vypn9sxarv2gw42hs2haasyvzqyp02s6vaqygp9xbg59m0x2l73";
      };
    }
    {
      name = "hammock-serenity.png";
      src = ./wallpapers/hammock-serenity.png;
    }
    {
      name = "anime-girl.png";
      src = ./wallpapers/anime-girl.png;
    }
    {
      name = "cute-puppy.png";
      src = ./wallpapers/cute-puppy.png;
    }
    {
      name = "calico-cat-oil-painting.png";
      src = ./wallpapers/calico-cat-oil-painting.png;
    }
    {
      name = "night-clouds.png";
      src = ./wallpapers/night-clouds.png;
    }
  ];
in
stdenvNoCC.mkDerivation {
  name = "wallpapers";
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out
  ''
  + builtins.concatStringsSep "\n"
      (map (wallpaper: "ln -s ${wallpaper.src} $out/${wallpaper.name}") wallpapers);
  meta = {
    description = "My wallpapers";
  };
  passthru.wallpaperNames = map (wallpaper: wallpaper.name) wallpapers;
}
