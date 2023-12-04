{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    #./hardware-configuration.nix
    ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      '';
    settings.trusted-users = [ "root" "quentin" ];
  };


  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  systemd.enableUnifiedCgroupHierarchy = false;
# Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.hardware.bolt.enable = true;

  networking = {
    hostName = "kagel";
    resolvconf.enable = true;
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    # networkmanager.enable = true;
    # networkmanager.dns = "default";
    # networkmanager.insertNameservers = ["8.8.8.8" "8.8.4.4"];
  };

  time.timeZone = "Europe/Paris";

  programs.dconf.enable = true;
  services.dbus.packages = [pkgs.dconf];

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;


  virtualisation = {
    docker.enable = true;
  };

# Enable the OpenSSH daemon.
  services.openssh.enable = true;

# Enable sound.
  sound.enable = true;

  hardware.bluetooth.enable = true;
  hardware.opengl.driSupport32Bit = true;

  services.xserver = {
    enable = true;
    layout = "us";
    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      defaultSession = "none+i3";
    };
    windowManager.i3 = {
      enable = true;
      configFile = ./../dotfiles/i3.conf;
      extraPackages = with pkgs; [
        dmenu
          i3status
          i3lock
          i3blocks
      ];
    };
    xkbModel = "pc105";
    xkbVariant = "altgr-intl";
    xkbOptions = "compose:rctrl";
  };
# Enable touchpad support.
  services.xserver.libinput.enable = true;

  # home-manager.users.quentin = { pkgs, ... }: {
  #   programs.home-manager.enable = true;
  #   # home.file.".config/sakura/sakura.conf".text =
  #   #   builtins.readFile "${my-dotfiles}/files/sakura.conf";


  #   home.packages = import ./packages.nix { inherit pkgs; };
  #   programs.zsh.enable = true;
  #   # The state version is required and should stay at the version you
  #   # originally installed.
  #   home.stateVersion = "23.05";
  # };

  environment.systemPackages = import ./base-packages.nix { inherit pkgs; };
  environment.variables = {
    LC_ALL = "en_US.UTF-8";
  };
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fontconfig = {
      enable = true;
      allowBitmaps = true;
      antialias = true;
      hinting.enable = true;
      includeUserConf = true;
      defaultFonts = {
        monospace = ["Fira Mono"];
        sansSerif = ["Fira Sans"];
        serif = ["DejaVu Serif"];
      };
    };

    fonts = with pkgs; [
      nerdfonts
      font-awesome_5
      iosevka-bin
      iosevka

      emojione
      liberation_ttf
      fira-code-symbols
      dina-font
      proggyfonts
      fira-code
      fira-mono
      hasklig
      wqy_zenhei
    ];
  };
  programs.zsh.enable = true;

  users.extraUsers.quentin = {
    isNormalUser = true;
    home = "/home/quentin";
    shell = pkgs.zsh;
    extraGroups = [
      "audio"
      "wheel"
      "networkmanager"
      "lp"
      "perf_users"
      "docker"
      "users"
    ];
    # openssh.authorizedKeys.keys = [(lib.readFile ../../../deployments/keys/id_rsa.pub)];
    # Set the initial password. Don't forget to change it ASAP.
    initialPassword = "nixos";
    uid = 1000;
  };


# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

