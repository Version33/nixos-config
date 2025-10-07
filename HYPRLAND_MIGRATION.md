# Hyprland Migration Guide

This document describes the changes made to integrate the Hyprland window manager from the dots-hyprland repository.

## Changes Made

### 1. Added Hyprland Flake Input (flake.nix)
- Added `dots-hyprland` input pointing to `github:Version33/dots-hyprland?dir=dist-nix`
- Configured it to follow `nixpkgs` and `home-manager` inputs to avoid version conflicts

### 2. Disabled Conflicting Desktop Environment (configuration.nix)
The following services were disabled to prevent conflicts with Hyprland:

- **KDE Plasma 6** (`services.desktopManager.plasma6.enable = false`)
  - Conflicts: KDE Plasma is a full desktop environment that conflicts with Hyprland
  
- **SDDM Display Manager** (`services.displayManager.sddm.enable = false`)
  - Conflicts: Hyprland auto-starts from TTY, SDDM is not needed
  
- **X11 Server** - KEPT ENABLED (`services.xserver.enable = true`)
  - Reason: Required for XWayland support with Hyprland

### 3. Enabled Hyprland at System Level (configuration.nix)
```nix
programs.hyprland = {
    enable = true;
    xwayland.enable = true;
};
```
This ensures Hyprland is properly integrated at the system level with XWayland support.

### 4. Configured Hyprland in Home Manager (home.nix)
- Imported the `dots-hyprland` Home Manager module
- Enabled the illogical-impulse configuration
- Set default monitor configuration to auto-detect
- Disabled KDE integration module
- Disabled backlight control (can be re-enabled for laptops)

## What This Enables

The dots-hyprland configuration includes:

### Enabled by Default:
- **Hyprland** - Wayland compositor with beautiful animations
- **Audio controls** - Volume and media controls
- **Basic utilities** - Core system tools
- **Fonts & themes** - Consistent theming across applications
- **XDG Desktop Portals** - For proper integration with applications
- **Screen capture** - Screenshot and recording tools
- **Quickshell widgets** - Status bar and other UI widgets
- **Bibata cursor theme** - Modern cursor theme

### Disabled by Default (can be enabled):
- **Backlight control** - Set `backlight.enable = true` for laptops
- **KDE integration** - Already disabled
- **LaTeX rendering** (microtex)
- **OneUI4 icons**
- **Python dev tools**

## Monitor Configuration

The default monitor configuration is set to auto-detect:
```nix
monitors = [ ",preferred,auto,1" ];
```

To configure specific monitors, update `home.nix`:
```nix
illogical-impulse.hyprland = {
    monitors = [
        "DP-1,2560x1440@144,0x0,1"
        "HDMI-A-1,1920x1080@60,2560x0,1"
    ];
    workspaces = [
        "1, monitor:DP-1, default:true"
        "2, monitor:HDMI-A-1"
    ];
};
```

## First Boot Instructions

After applying this configuration:

1. **Rebuild the system:**
   ```bash
   sudo nixos-rebuild switch --flake .#nixos
   ```

2. **Logout** if you're currently in a session

3. **From TTY1** (Ctrl+Alt+F1), Hyprland should auto-start, or you can manually start it:
   ```bash
   Hyprland
   ```

4. **Learn the keybindings:**
   - `Super + Return` - Terminal
   - `Super + Q` - Close window
   - `Super + D` - Application launcher
   - See the dots-hyprland documentation for complete keybindings

## Reverting Changes

If you need to go back to KDE Plasma:

1. In `configuration.nix`, set:
   ```nix
   services.displayManager.sddm.enable = true;
   services.desktopManager.plasma6.enable = true;
   programs.hyprland.enable = false;
   ```

2. In `home.nix`, comment out or remove:
   ```nix
   imports = [
       # inputs.dots-hyprland.homeManagerModules.default
   ];
   
   # illogical-impulse = { ... };
   ```

3. Rebuild and reboot

## Additional Configuration

The Hyprland configuration files from dots-hyprland will be deployed to:
- `~/.config/hypr/` - Main Hyprland config
- `~/.config/quickshell/` - Widget configuration
- `~/.config/kitty/` - Terminal configuration
- `~/.config/fuzzel/` - App launcher
- And more...

You can customize these by modifying the options in the `illogical-impulse` section of `home.nix`.

## Troubleshooting

### Monitor not detected
Update the monitors configuration in `home.nix` with your specific monitor IDs (use `hyprctl monitors` to list them).

### Applications don't launch
Ensure XDG portals are working: `echo $XDG_CURRENT_DESKTOP` should show `Hyprland`.

### No audio controls
The audio module is enabled by default. Check if `pwvucontrol` or similar is installed.

### Backlight control not working (laptops)
Enable it: `illogical-impulse.backlight.enable = true;` in `home.nix`.

## References

- [dots-hyprland repository](https://github.com/Version33/dots-hyprland)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
