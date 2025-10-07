# End-4 Dots-Hyprland Configuration Module

This module provides a NixOS/Home Manager configuration for setting up an end-4 dots-hyprland inspired Hyprland desktop environment.

## Features

This flake provides toggleable components for a complete Hyprland setup:

- **Hyprland**: The dynamic tiling Wayland compositor
- **AGS** (Aylur's GTK Shell): Widget system for creating custom UI elements
- **EWW**: Alternative widget system (Elkowar's Wacky Widgets)
- **Waybar**: Status bar for Wayland
- **SwayNC**: Notification daemon
- **Rofi**: Application launcher (Wayland version)
- **Hyprlock**: Screen locker
- **SWWW/Hyprpaper**: Wallpaper daemons
- **Utilities**: Screenshots (grim/slurp), clipboard (cliphist), media controls (playerctl), brightness control, etc.

## Usage

### Enable in Home Manager

The module is imported in `home.nix` by default but disabled. To enable:

```nix
programs.dots-hyprland = {
  enable = true;
};
```

### Customization

You can customize which components to enable:

```nix
programs.dots-hyprland = {
  enable = true;
  
  # Core components (default: true)
  hyprland.enable = true;
  
  # Widget systems (AGS default: true, EWW default: false)
  ags.enable = true;
  eww.enable = false;
  
  # Status bar (default: false, since AGS provides its own bar)
  waybar.enable = false;
  
  # Notifications (default: true)
  notifications.enable = true;
  
  # Launcher (default: true)
  launcher.enable = true;
  
  # Screen lock (default: true)
  screenLock.enable = true;
  
  # Wallpaper (default: true with swww)
  wallpaper = {
    enable = true;
    backend = "swww"; # or "hyprpaper"
  };
  
  # Utilities (default: true)
  utilities.enable = true;
};
```

## What's Installed

When enabled, the module installs:

### Core
- Hyprland compositor
- Terminal emulators (foot, kitty)
- XDG utilities

### Widgets & UI
- AGS (if enabled)
- EWW (if enabled)
- Waybar (if enabled)

### System Utilities
- grim & slurp (screenshots)
- wl-clipboard (clipboard utilities)
- cliphist (clipboard history)
- brightnessctl (brightness control)
- playerctl (media control)
- pavucontrol (volume control)
- networkmanagerapplet (network management)
- blueman (Bluetooth management)
- udiskie (automatic disk mounting)
- system monitor

### Daemons & Services
- Notification daemon (SwayNC)
- Wallpaper daemon (SWWW or Hyprpaper)
- Clipboard history service
- Bluetooth applet
- Network manager applet

## Integration

The module follows the same pattern as the existing `audio` and `secure-boot` modules in this repository:

1. It's a separate flake in the `dots-hyprland/` directory
2. It's referenced as a path input in the main `flake.nix`
3. It's imported as a Home Manager module in `home.nix`
4. It provides toggleable options with sensible defaults

## Differences from Original

This is a Nix-native implementation inspired by end-4's dots-hyprland. The main differences:

- Uses Nix packages from nixpkgs instead of Arch packages
- Configured via Nix options rather than shell scripts
- Integrates with Home Manager for declarative configuration
- All components are optional and can be toggled on/off

## References

- [End-4 Dots Hyprland](https://github.com/end-4/dots-hyprland)
- [End-4 Dots Hyprland Wiki](https://end-4.github.io/dots-hyprland-wiki/)
