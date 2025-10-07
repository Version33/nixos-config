# User Guide: End-4 Dots-Hyprland Module

## What Is This?

This module provides a complete Hyprland desktop environment based on end-4's dots-hyprland project, packaged as a Nix flake for easy installation and configuration through Home Manager.

## Quick Start (3 Steps)

### 1. Enable the Module

In your `home.nix`, change line 44 from:
```nix
enable = false; # Set to true to enable the Hyprland setup
```

To:
```nix
enable = true; # Set to true to enable the Hyprland setup
```

### 2. Rebuild Your System

```bash
sudo nixos-rebuild switch --flake .#nixos
```

### 3. Start Hyprland

Log out and select "Hyprland" from your display manager (SDDM), or from a TTY run:
```bash
Hyprland
```

## What You Get

When enabled with defaults, you'll have a complete desktop environment:

| Component | Purpose |
|-----------|---------|
| **Hyprland** | Wayland compositor (your desktop) |
| **AGS** | Widgets and status bar |
| **SwayNC** | Notifications |
| **Rofi** | Application launcher |
| **Hyprlock** | Screen locker |
| **SWWW** | Wallpaper daemon |
| **Foot/Kitty** | Terminal emulators |
| **+ Utilities** | Screenshots, clipboard, media controls, etc. |

## Customization

### Example 1: Use Waybar Instead of AGS

```nix
programs.dots-hyprland = {
  enable = true;
  ags.enable = false;
  waybar.enable = true;
};
```

### Example 2: Use EWW Instead of AGS

```nix
programs.dots-hyprland = {
  enable = true;
  ags.enable = false;
  eww.enable = true;
  waybar.enable = true;  # Often used with EWW
};
```

### Example 3: Minimal Setup

```nix
programs.dots-hyprland = {
  enable = true;
  ags.enable = false;
  waybar.enable = true;
  utilities.enable = false;  # Install utilities manually
};
```

### Example 4: Change Wallpaper Backend

```nix
programs.dots-hyprland = {
  enable = true;
  wallpaper = {
    enable = true;
    backend = "hyprpaper";  # Default is "swww"
  };
};
```

## All Available Options

```nix
programs.dots-hyprland = {
  enable = true;                      # Master switch
  
  hyprland.enable = true;             # Hyprland compositor
  ags.enable = true;                  # AGS widgets
  eww.enable = false;                 # EWW widgets
  waybar.enable = false;              # Waybar status bar
  notifications.enable = true;        # SwayNC notifications
  launcher.enable = true;             # Rofi launcher
  screenLock.enable = true;           # Hyprlock screen locker
  
  wallpaper = {
    enable = true;                    # Wallpaper daemon
    backend = "swww";                 # "swww" or "hyprpaper"
  };
  
  utilities.enable = true;            # All utilities below
};
```

### Utilities Include:
- **Screenshots**: grim, slurp
- **Clipboard**: wl-clipboard, cliphist
- **Media**: playerctl, pavucontrol
- **System**: brightnessctl, networkmanagerapplet, blueman, udiskie
- And more...

## Troubleshooting

### "Module not found" Error
Make sure you've saved `home.nix` and run `nixos-rebuild switch`.

### Missing Packages
Some packages might not be in your nixpkgs version. Try:
```bash
nix flake update
sudo nixos-rebuild switch --flake .#nixos
```

### Disable Specific Component
Set any component to `false`:
```nix
programs.dots-hyprland = {
  enable = true;
  ags.enable = false;  # Don't install AGS
};
```

### Completely Disable
```nix
programs.dots-hyprland.enable = false;
```

## Further Configuration

For Hyprland-specific configuration (keybindings, appearance, etc.), see the [Hyprland Wiki](https://wiki.hyprland.org/).

Example in your `home.nix`:
```nix
wayland.windowManager.hyprland.settings = {
  "$mod" = "SUPER";
  
  bind = [
    "$mod, Return, exec, foot"
    "$mod, D, exec, rofi -show drun"
    "$mod, Q, killactive"
    # ... more keybinds
  ];
};
```

## More Information

- **README.md**: Complete feature documentation
- **QUICKSTART.md**: Detailed setup instructions
- **examples.nix**: More configuration examples
- **IMPLEMENTATION_SUMMARY.md**: Technical details

## Need Help?

Check the documentation files in the `dots-hyprland/` directory, or see the [Hyprland documentation](https://wiki.hyprland.org/) for general Hyprland help.
