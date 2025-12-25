{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      claude-code
      gemini-cli
      opencode
      codex
    ];

    file.".codex/AGENTS.md" = {
      source = ./AGENTS.md;
    };
  };
}
