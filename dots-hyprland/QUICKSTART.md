# Quick Start Guide

## 1. Enable the Module

In your `home.nix`, the module is already imported but disabled by default. To enable it:

```nix
programs.dots-hyprland = {
  enable = true;
};
```

## 2. Rebuild Your Configuration

```bash
# For NixOS with Home Manager
sudo nixos-rebuild switch --flake .#nixos

# Or if using standalone Home Manager
home-manager switch --flake .
```

## 3. Start Hyprland

If you're using a display manager (like SDDM), select Hyprland from the session menu.

To start from TTY:
```bash
Hyprland
```

## 4. What You Get

Once enabled with defaults, you'll have:

- **Hyprland**: Your Wayland compositor
- **AGS**: Widget system for custom UI (bars, menus, etc.)
- **SwayNC**: Notification daemon
- **Rofi**: Application launcher (Super+D or configured keybind)
- **Hyprlock**: Screen locker
- **SWWW**: Wallpaper daemon
- **Foot/Kitty**: Terminal emulators
- **Utilities**: Screenshot tools, clipboard manager, media controls, etc.

## 5. Customize

See `examples.nix` for different configuration patterns, or check the README.md for all available options.

## 6. Key Components

### AGS vs EWW vs Waybar

The module lets you choose your widget/bar system:

- **AGS** (default): Modern, TypeScript-based widget system
- **EWW**: Lisp-based widget system, very customizable
- **Waybar**: Traditional status bar

You typically enable only one of these, though they can coexist.

### Wallpaper Backends

- **SWWW** (default): More feature-rich, supports animated wallpapers
- **Hyprpaper**: Lighter, simpler wallpaper daemon

## 7. Troubleshooting

### Module not found error
If you get an error about the module not being found, make sure:
1. The `dots-hyprland` input is in your `flake.nix`
2. The import is in your `home.nix`
3. You've run `nix flake update` if needed

### Package not available
Some packages might not be available in your nixpkgs version. Update nixpkgs or disable that specific component.

## 8. Further Configuration

For detailed Hyprland configuration (keybinds, rules, appearance), you'll want to add:

```nix
wayland.windowManager.hyprland.settings = {
  # Your Hyprland configuration here
  "$mod" = "SUPER";
  
  bind = [
    "$mod, Return, exec, foot"
    "$mod, D, exec, rofi -show drun"
    # ... more keybinds
  ];
  
  # ... more settings
};
```

See the [Hyprland Wiki](https://wiki.hyprland.org/) for comprehensive configuration options.
