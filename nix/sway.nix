# sway.nix imported by my configuration.nix
{ pkgs, ... }:

{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Needed for GTK apps to work.
    extraSessionCommands = ''
    export SDL_VIDEODRIVER = wayland
    export QT_QPA_PLATFORM = wayland
    export XDG_SESSION_TYPE = wayland 
    '';
  };

  # XWayland depends on this (already declared in configuration.nix) 
  # services.xserver.enable = true;
  # Required for Sway as per https://nixos.wiki/wiki/Sway
  security.polkit.enable = true;

  # Allow user to run swaylock
  # security.pam.services.swaylock = {};

  # Required for brightness and volume keys (accompanied by some sway config stuff)
  users.users.bashbunni.extraGroups = [ "video" ];
  programs.light.enable = true;

  # Other basic settings
  networking.networkmanager.enable = true; # for internet
  services.blueman.enable = true; # for bluetooth

  # Select between Gnome and Sway at Startup
#  services.xserver.displayManager.sessionPackages = with pkgs; [ sway ];

  environment.systemPackages = with pkgs; [
    ulauncher # A program launcher
    xdg-desktop-portal
  ];
  # Fix waybar not launching outside of dbus-run-session.
  xdg.portal.enable = true;
}
