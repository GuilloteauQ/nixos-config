{
  pkgs,
  config,
  ...
}: {

  home.username = "quentin";
  home.homeDirectory = "/home/quentin";
    home.stateVersion = "23.05";

    programs.home-manager.enable = true;
   #  home.file.".config/i3/conf".text =
   #    builtins.readFile ../dotfiles/i3.conf;

    home.file.".tmux.conf".text =
      builtins.readFile ../dotfiles/tmux.conf;

    home.packages = import ./packages.nix { inherit pkgs; };
}

