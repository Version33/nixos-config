# Quick Start Guide - Hyprland Integration

## TL;DR - What Changed

✅ **Added:** Hyprland window manager from dots-hyprland repository  
❌ **Removed:** KDE Plasma 6 and SDDM (conflicts resolved)  
✅ **Kept:** All audio production, gaming, and development tools  

## Deploy the Changes

```bash
# 1. Update flake dependencies
nix flake update

# 2. Build and switch to new configuration
sudo nixos-rebuild switch --flake .#nixos

# 3. Logout or reboot
# Hyprland will auto-start on TTY1
```

## Essential Hyprland Keybindings

| Key Combination | Action |
|----------------|--------|
| `Super + Return` | Open terminal (Kitty) |
| `Super + Q` | Close window |
| `Super + D` | Application launcher (Fuzzel) |
| `Super + 1-9` | Switch workspace |
| `Super + Shift + 1-9` | Move window to workspace |
| `Super + F` | Toggle fullscreen |
| `Super + V` | Toggle floating |
| `Super + Mouse` | Move/resize window |
| `Super + L` | Lock screen |
| `Super + Shift + E` | Exit menu |

## First Time Setup

### 1. After First Boot
Hyprland should auto-start. If not:
```bash
Hyprland
```

### 2. Configure Your Monitors
Edit `home.nix`:
```nix
illogical-impulse.hyprland = {
    monitors = [
        "DP-1,2560x1440@144,0x0,1"
        "HDMI-A-1,1920x1080@60,2560x0,1"
    ];
};
```

Then rebuild:
```bash
sudo nixos-rebuild switch --flake .#nixos
```

### 3. List Your Monitors
```bash
hyprctl monitors
```

## Common Tasks

### Install a File Manager
```bash
# Add to home.nix packages:
home.packages = with pkgs; [
    # ... existing packages ...
    dolphin  # or: nautilus, thunar, nemo
];
```

### Enable Laptop Backlight Control
In `home.nix`:
```nix
illogical-impulse.backlight.enable = true;
```

### Customize Hyprland Config
Configuration files are at:
- `~/.config/hypr/hyprland.conf` - Main config
- `~/.config/hypr/custom/` - Your customizations
- `~/.config/quickshell/` - Status bar/widgets

## Troubleshooting

### Hyprland Won't Start
```bash
# Check logs
cat ~/.cache/hyprland.log

# Try starting manually from TTY
Hyprland
```

### Applications Won't Launch
```bash
# Verify XDG portals
echo $XDG_CURRENT_DESKTOP  # Should show: Hyprland

# Reinstall portals if needed
```

### Monitor Configuration Not Working
```bash
# List connected monitors
hyprctl monitors

# Test monitor config
hyprctl keyword monitor "DP-1,1920x1080@60,0x0,1"
```

### Audio Not Working
Audio configuration is unchanged. If issues:
```bash
# Check PipeWire status
systemctl --user status pipewire

# Test audio
pactl info
```

### Steam/Games Issues
```bash
# Ensure XWayland is working
echo $DISPLAY  # Should show something like :0

# Try launching Steam with:
steam
```

## Rollback to KDE Plasma

If you need to go back:

```bash
# Edit configuration.nix
services.displayManager.sddm.enable = true;
services.desktopManager.plasma6.enable = true;
programs.hyprland.enable = false;

# Comment out in home.nix:
# imports = [ inputs.dots-hyprland.homeManagerModules.default ];
# illogical-impulse = { ... };

# Rebuild
sudo nixos-rebuild switch --flake .#nixos
```

Or use the previous generation:
```bash
sudo nixos-rebuild switch --rollback
```

## What Works Out of the Box

✅ Window management with animations  
✅ Application launcher (Super+D)  
✅ System widgets and status bar  
✅ Audio controls  
✅ Screen capture (screenshots/recording)  
✅ Screen locking  
✅ Multi-monitor support  
✅ Gaming (Steam, Proton, etc.)  
✅ Audio production (Bitwig, VSTs)  
✅ All your existing applications  

## What You Might Miss from KDE

❌ Graphical system settings (use config files)  
❌ KDE Connect (can install separately)  
❌ Dolphin by default (can install)  
❌ KRunner (replaced by Fuzzel)  
❌ System tray icons may look different  

## Getting Help

1. **Check the logs:** `~/.cache/hyprland.log`
2. **Read the docs:** See `HYPRLAND_MIGRATION.md`
3. **Hyprland Wiki:** https://wiki.hyprland.org/
4. **dots-hyprland:** https://github.com/Version33/dots-hyprland
5. **Hyprland Discord:** https://discord.gg/hT8K9WRNYk

## Files You Can Edit

- `home.nix` - Hyprland options, monitor config
- `~/.config/hypr/custom/*.conf` - Hyprland customizations
- `~/.config/quickshell/` - Widget customizations
- `~/.config/kitty/kitty.conf` - Terminal settings

## Next Steps

1. ✅ Deploy the configuration
2. ✅ Test Hyprland startup
3. ✅ Configure monitors if needed
4. ✅ Test your critical applications
5. ✅ Customize to your liking
6. ✅ Enjoy your new Hyprland setup!

---

**Need more details?** Read:
- `CONFLICTS_RESOLVED.md` - Full conflict analysis
- `CHANGES_SUMMARY.md` - Detailed changes
- `HYPRLAND_MIGRATION.md` - Complete guide
