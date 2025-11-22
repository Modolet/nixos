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
    (builtins.concatStringsSep "\n" (
      map (
        key:
        mkKeyBinding {
          inherit key;
          command = "notify-send 'entering mode ${name}' && @enter ${name}";
        }
      ) enterKeys
    ))
    + "\n"
    + ''
      mode ${name} ${swallowStr} ${oneoffStr}
    ''
    + (builtins.concatStringsSep "\n" (map mkKeyBinding keyBindings))
    + "\n"
    + (builtins.concatStringsSep "\n" (
      map (
        key:
        mkKeyBinding {
          inherit key;
          command = "notify-send 'exiting mode ${name}' && @escape";
        }
      ) escapeKeys
    ))
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