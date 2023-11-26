{
  nixpkgs,
  options,
  modulesPath,
  lib,
  config,
  home-module,
  pkgs,
  ...
}: {

  config = {
    programs.home-manager.enable = true;
    home.file.".config/i3.conf".text =
      builtins.readFile ../dotfiles/i3.conf;

    home.file.".tmux.conf".text =
      builtins.readFile ../dotfiles/tmux.conf;

    home.packages = import ../deployments/packages.nix { inherit pkgs; };
  };
}

