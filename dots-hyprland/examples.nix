# Example Configuration for dots-hyprland

# This file shows different ways to configure the dots-hyprland module.
# Copy the relevant sections to your home.nix file.

## Example 1: Enable with all defaults
programs.dots-hyprland = {
  enable = true;
};

## Example 2: Minimal Hyprland setup (just compositor and essentials)
programs.dots-hyprland = {
  enable = true;
  ags.enable = false;
  waybar.enable = true;  # Use Waybar instead of AGS
};

## Example 3: Use EWW instead of AGS
programs.dots-hyprland = {
  enable = true;
  ags.enable = false;
  eww.enable = true;
  waybar.enable = true;  # Often used with EWW
};

## Example 4: Full customization
programs.dots-hyprland = {
  enable = true;
  
  # Core
  hyprland.enable = true;
  
  # Widgets (choose one: AGS or EWW)
  ags.enable = true;
  eww.enable = false;
  
  # Status bar (optional if using AGS)
  waybar.enable = false;
  
  # System components
  notifications.enable = true;
  launcher.enable = true;
  screenLock.enable = true;
  
  # Wallpaper
  wallpaper = {
    enable = true;
    backend = "swww";  # or "hyprpaper"
  };
  
  # Utilities
  utilities.enable = true;
};

## Example 5: Disable specific utilities but keep others
programs.dots-hyprland = {
  enable = true;
  # All other defaults apply
};

# To disable the entire module
programs.dots-hyprland.enable = false;
