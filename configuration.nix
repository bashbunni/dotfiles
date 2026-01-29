# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      /home/bashbunni/dotfiles/nix/sway.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
  # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Enable the GNOME Desktop Environment.
# replaced in sway.nix
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bashbunni = {
    isNormalUser = true;
    home = "/home/bashbunni";
    description = "bashbunni";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = false;
  services.xserver.displayManager.autoLogin.user = "bashbunni";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs = {
    firefox.enable = true;
    fish.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-57-6.12.41"
  ];

# Use emacs overlay. Required for Emacs 28+.
# Use a commit SHA for a specific commit to prevent overlay rebuild every time (can be very long).
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/emacs-overlay/archive/87181272bf633bbc9f19a8aa8662833940bf18ed.tar.gz";
    }))
  ];

# List packages installed in system profile. To search, run:
# $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git
    vim
    stow
    ripgrep
    discord
    brave
    flameshot
    kitty
    fish
    emacs
    rofi
    yubikey-agent
    keepassxc
    swayfx
    waybar
    xss-lock
    pkgs.networkmanagerapplet
    playerctl
    pavucontrol
    lolcat
    xorg.xkill
    wl-clipboard
    # xclip
    coreutils
    element-web
    zed-editor
# rust stuff
    jetbrains.rust-rover
# emacs deps
# make packages available to emacsclient (see nixos wiki's emacs docs)
    emacsPackages.pbcopy
    emacsPackages.vterm
    libvterm
    libtool
    gcc
    glibc
    libcxx
    gdb
    cmake
    gnumake
    libgcc
    pam_u2f
    ispell
# language servers
    gopls
    haskell-language-server
# languages
    go
# yak shaving
    wl-mirror # mirror your display (used in sway config)
    greetd
    tuigreet
  ];

  fonts = {
    packages = with pkgs; [
      nerd-fonts.terminess-ttf
      nerd-fonts.blex-mono
      ibm-plex
      openmoji-color	
    ];       
    fontconfig = {
        defaultFonts = {
          sansSerif = [ "IBM Plex Sans" ];
          serif = [ "IBM Plex Serif" ];
          monospace = [ "Terminess Nerd Font" ];
          emoji = [ "OpenMoji Color" ];
        };
    };
    enableDefaultFonts = true;
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  nix.extraOptions = ''
    experimental-features = nix-command flakes 
  '';

# Yubikey for sudo
security.pam.services = {
  sudo = {
    u2fAuth = true;
  };
};

  # Required for Polkit and D-Bus permissions
#  security.polkit.enable = true;

  # Allow user to run swaylock
  # security.pam.services.swaylock = {};

# Make sure waybar always runs
# programs.waybar = {
#   enable = true;
# };

}
