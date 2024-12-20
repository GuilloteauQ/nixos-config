{ pkgs }:

let
  emacs_with_packages = pkgs.emacs29.pkgs.withPackages (epkgs: (with epkgs.melpaStablePackages; [
    magit
    pdf-tools
    evil
    snakemake-mode
    which-key
]) ++ (with epkgs.melpaPackages; [
    vterm
    ess
  ]));
  config = ./config.el;
  myEmacs = pkgs.writeShellScriptBin "emacs" ''
    exec ${emacs_with_packages}/bin/emacs -q --load ${config} $@
  '';
in

with pkgs; [
  git-annex
  # home-manager
  #emacs
  myEmacs
  tmux
  # firefox
  docker
  # thunderbird
  alacritty
  arandr
  bat
  evince
  ghq
  # helix
  # libreoffice
  neovim
  # mattermost-desktop
  # pavucontrol
  tree
  telegram-desktop
  slack
  nixfmt
  # gdb
  gnome.eog
  inkscape
  xournalpp
  yubikey-manager
  # yubioath-flutter

  wget
  vim
  htop
  tmux
  # git
  jq
  # acpi
  nerdfonts
  powerline-fonts
  font-awesome_5
  iosevka-bin
  iosevka
  
  #emojione
  liberation_ttf
  fira-code-symbols
  dina-font
  # proggyfonts
  fira-code
  fira-mono
  hasklig
  wqy_zenhei
]
