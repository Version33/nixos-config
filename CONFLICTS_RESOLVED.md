# Conflicts Resolved for Hyprland Integration

## Summary
All potential conflicts between the existing KDE Plasma 6 desktop environment and the new Hyprland configuration have been identified and resolved.

## Conflict Matrix

| Component | Before | After | Reason |
|-----------|--------|-------|--------|
| **Display Manager** | SDDM (enabled) | SDDM (disabled) | Hyprland auto-starts from TTY1, SDDM not needed |
| **Desktop Environment** | KDE Plasma 6 (enabled) | KDE Plasma 6 (disabled) | Conflicts with Hyprland compositor |
| **Window Compositor** | KWin (via Plasma) | Hyprland | Switched to Hyprland Wayland compositor |
| **X11 Server** | Enabled | Enabled (kept) | Required for XWayland support |
| **Audio System** | Pipewire | Pipewire (unchanged) | No conflict, both use Pipewire |
| **Audio Groups** | realtime, audio | realtime, audio (unchanged) | No conflict |
| **Network Manager** | Enabled | Enabled (unchanged) | No conflict |
| **Steam** | Enabled | Enabled (unchanged) | No conflict |
| **Home Manager** | Enabled | Enabled (unchanged) | No conflict |

## Configuration Changes Detail

### flake.nix
```nix
# ADDED: New flake input
dots-hyprland = {
    url = "github:Version33/dots-hyprland?dir=dist-nix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.home-manager.follows = "home-manager";
};
```

### configuration.nix
```nix
# CHANGED: Display manager and desktop environment
services.displayManager.sddm.enable = false;        # Was: true
services.desktopManager.plasma6.enable = false;     # Was: true

# ADDED: Hyprland at system level
programs.hyprland = {
    enable = true;
    xwayland.enable = true;
};

# KEPT: X11 server for XWayland
services.xserver.enable = true;  # No change
```

### home.nix
```nix
# ADDED: Import Hyprland dotfiles
imports = [
    inputs.dots-hyprland.homeManagerModules.default
];

# ADDED: Hyprland configuration
illogical-impulse = {
    enable = true;
    hyprland = {
        monitors = [ ",preferred,auto,1" ];
        workspaces = [ "1, monitor:auto, default:true" ];
    };
    kde.enable = false;
    backlight.enable = false;
};
```

## No Conflicts With

✅ **Audio Production Setup**
- Pipewire configuration unchanged
- Realtime audio groups preserved
- VST plugin configuration (yabridge) intact
- Bitwig Studio and audio tools will work

✅ **Gaming Setup**
- Steam configuration unchanged
- GPU drivers (AMD) unchanged
- Hardware acceleration maintained

✅ **User Environment**
- Nushell configuration preserved
- Git configuration unchanged
- VSCode and development tools intact
- All user packages maintained

✅ **System Services**
- Network Manager unchanged
- Printing services unchanged
- USB permissions unchanged
- Secure boot configuration unchanged

## Boot Sequence Changes

### Before (with KDE)
1. GRUB/systemd-boot
2. Linux kernel
3. systemd init
4. SDDM display manager starts
5. User logs into KDE Plasma
6. KWin compositor starts

### After (with Hyprland)
1. GRUB/systemd-boot
2. Linux kernel
3. systemd init
4. Getty starts on TTY1
5. Auto-login or manual login
6. Hyprland auto-starts (via Fish shell config from dots-hyprland)

## Feature Parity

| Feature | KDE Plasma 6 | Hyprland (dots-hyprland) |
|---------|--------------|--------------------------|
| Window Management | ✅ | ✅ |
| System Tray | ✅ | ✅ (Quickshell widgets) |
| Application Launcher | ✅ (KRunner) | ✅ (Fuzzel) |
| Screen Lock | ✅ (KScreenlocker) | ✅ (Hyprlock) |
| Power Management | ✅ | ✅ (Hypridle) |
| Screen Capture | ✅ (Spectacle) | ✅ (grim/slurp) |
| Audio Controls | ✅ (Plasma widgets) | ✅ (Quickshell widgets) |
| File Manager | ✅ (Dolphin) | ⚠️ Need to install separately |
| System Settings | ✅ (KDE Settings) | ⚠️ Manual config files |

## Applications Still Available

Even with KDE Plasma disabled, these KDE applications remain available:

- Kate (text editor) - in user packages
- Dolphin - can be installed if needed
- Konsole - can be installed if needed
- KDE applications via flatpak/packages

The KDE integration module in dots-hyprland is disabled to avoid conflicts, but KDE apps will still run under Hyprland.

## Testing Checklist

Before declaring success, test these scenarios:

- [ ] System boots to TTY
- [ ] Hyprland starts (manually or auto)
- [ ] Audio controls work
- [ ] Application launcher works (Super+D)
- [ ] Window management works
- [ ] Steam launches and games run
- [ ] Bitwig Studio opens
- [ ] VST plugins work via yabridge
- [ ] Firefox/browsers work
- [ ] Screenshots work
- [ ] Screen lock works
- [ ] Multi-monitor setup (if applicable)

## Emergency Recovery

If Hyprland fails to start or has critical issues:

1. **From TTY:** Press Ctrl+Alt+F2 to get to TTY2
2. **Temporarily revert:** Edit `/etc/nixos/configuration.nix` to re-enable SDDM/Plasma
3. **Rebuild:** `sudo nixos-rebuild switch`
4. **Reboot**

Or use previous generation:
```bash
sudo nixos-rebuild switch --rollback
```

## Performance Considerations

### Expected Improvements
- ✅ Lower memory usage (no full DE overhead)
- ✅ Faster window animations (Wayland native)
- ✅ Better multi-monitor handling
- ✅ Reduced input latency

### Potential Trade-offs
- ⚠️ Manual configuration required
- ⚠️ Learning curve for new keybindings
- ⚠️ Some KDE-specific integrations won't work

## Conclusion

All conflicts have been systematically identified and resolved. The system should boot cleanly with Hyprland, while preserving all critical functionality for audio production, gaming, and development work.
