let
  mkKeyBinding =
    {
      key,
      command,
      onRelease ? false,
      swallow ? true,
    }:
    let
      onReleasePrefix = if onRelease then "@" else "";
      swallowPrefix = if swallow then "" else "~";
    in
    ''
      ${onReleasePrefix}${swallowPrefix}${key}
              ${command}'';
  mkMode =
    {
      name,
      swallow ? true,
      oneoff ? false,
      keyBindings,
      enterKeys ? [ ],
      escapeKeys ? [ ],
    }:
    let
      swallowStr = if swallow then "swallow" else "";
      oneoffStr = if oneoff then "oneoff" else "";
    in
    (
      map (
        key:
        mkKeyBinding {
          inherit key;
          command = "notify-send 'entering mode ${name}' && @enter ${name}";
        }
      (builtins.concatStringsSep "\n" enterKeys)
    )
    + "\n"
    + ''
      mode ${name} ${swallowStr} ${oneoffStr}
    ''
    + (builtins.concatStringsSep "\n" (map mkKeyBinding keyBindings))
    + "\n"
    + (
      map (
        key:
        mkKeyBinding {
          inherit key;
          command = "notify-send 'exiting mode ${name}' && @escape";
        }
      (builtins.concatStringsSep "\n" escapeKeys)
    )
    + "\n"
    + ''
      endmode
    '';
  mkSwhkdrc =
    {
      keyBindings,
      includes ? [ ],
      ignores ? [ ],
      modes ? [ ],
      extraConfig ? '''',
    }:
    builtins.concatStringsSep "\n" (
      (map (file: "include ${file}") includes)
      ++ (map (key: "ignore ${key}") ignores)
      ++ (map mkKeyBinding keyBindings)
      ++ (map mkMode modes)
    )
    + extraConfig;
in
{
  lib.swhkd = { inherit mkSwhkdrc; };
}