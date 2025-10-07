{
	description = "End-4 dots-hyprland inspired configuration flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	};

	outputs = { self, nixpkgs }:
		let
			system = "x86_64-linux";
			pkgs = import nixpkgs {
				inherit system;
				config.allowUnfree = true;
			};
		in
		{
			# Home Manager module
			homeManagerModules.default = { config, lib, pkgs, ... }:
				let
					cfg = config.programs.dots-hyprland;
				in
				{
					options.programs.dots-hyprland = {
						enable = lib.mkEnableOption "End-4 dots-hyprland configuration";

						# Core components
						hyprland.enable = lib.mkOption {
							type = lib.types.bool;
							default = true;
							description = "Enable Hyprland compositor";
						};

						# Widget systems
						ags.enable = lib.mkOption {
							type = lib.types.bool;
							default = true;
							description = "Enable AGS (Aylur's GTK Shell) widgets";
						};

						eww.enable = lib.mkOption {
							type = lib.types.bool;
							default = false;
							description = "Enable EWW widgets";
						};

						# Status bar
						waybar.enable = lib.mkOption {
							type = lib.types.bool;
							default = false;
							description = "Enable Waybar status bar";
						};

						# Notifications
						notifications.enable = lib.mkOption {
							type = lib.types.bool;
							default = true;
							description = "Enable notification daemon (swaync)";
						};

						# Launcher
						launcher.enable = lib.mkOption {
							type = lib.types.bool;
							default = true;
							description = "Enable application launcher (rofi-wayland)";
						};

						# Screen locking
						screenLock.enable = lib.mkOption {
							type = lib.types.bool;
							default = true;
							description = "Enable screen locking (hyprlock)";
						};

						# Wallpaper
						wallpaper = {
							enable = lib.mkOption {
								type = lib.types.bool;
								default = true;
								description = "Enable wallpaper daemon";
							};
							backend = lib.mkOption {
								type = lib.types.enum [ "swww" "hyprpaper" ];
								default = "swww";
								description = "Wallpaper backend to use";
							};
						};

						# Utilities
						utilities.enable = lib.mkOption {
							type = lib.types.bool;
							default = true;
							description = "Enable various utilities (clipboard, screenshot, etc.)";
						};
					};

					config = lib.mkIf cfg.enable {
						home.packages = with pkgs; lib.flatten [
							# Core Hyprland
							(lib.optional cfg.hyprland.enable hyprland)

							# Widget systems
							(lib.optional cfg.ags.enable ags)
							(lib.optional cfg.eww.enable eww)

							# Status bar
							(lib.optional cfg.waybar.enable waybar)

							# Notifications
							(lib.optional cfg.notifications.enable swaynotificationcenter)

							# Launcher
							(lib.optional cfg.launcher.enable rofi-wayland)

							# Screen lock
							(lib.optional cfg.screenLock.enable hyprlock)

							# Wallpaper
							(lib.optionals cfg.wallpaper.enable (
								if cfg.wallpaper.backend == "swww" then [ swww ]
								else [ hyprpaper ]
							))

							# Utilities
							(lib.optionals cfg.utilities.enable [
								grim              # Screenshot tool
								slurp             # Screen area selection
								wl-clipboard      # Wayland clipboard utilities
								cliphist          # Clipboard history
								brightnessctl     # Brightness control
								playerctl         # Media player control
								pavucontrol       # PulseAudio volume control
								networkmanagerapplet  # Network manager applet
								blueman           # Bluetooth manager
								udiskie           # Disk automounting
								gnome-system-monitor  # System monitor
							])

							# Additional common dependencies
							(lib.optionals cfg.enable [
								xdg-utils         # XDG utilities
								gtk3              # GTK3 runtime
								libnotify         # Desktop notifications library
								curl              # Network transfer tool
								wget              # Network downloader
								jq                # JSON processor
								bc                # Calculator
								coreutils         # Core utilities
								imagemagick       # Image manipulation
								ffmpeg            # Multimedia framework
								socat             # Socket utilities
								foot              # Terminal emulator
								kitty             # Alternative terminal
							])
						];

						# Enable Hyprland if requested
						wayland.windowManager.hyprland = lib.mkIf cfg.hyprland.enable {
							enable = true;
							xwayland.enable = true;
						};

						# Configure programs
						programs = {
							# AGS configuration
							ags = lib.mkIf cfg.ags.enable {
								enable = true;
							};

							# EWW configuration
							eww = lib.mkIf cfg.eww.enable {
								enable = true;
							};

							# Waybar configuration
							waybar = lib.mkIf cfg.waybar.enable {
								enable = true;
								systemd.enable = true;
							};

							# Rofi configuration
							rofi = lib.mkIf cfg.launcher.enable {
								enable = true;
								package = pkgs.rofi-wayland;
							};
						};

						# Services
						services = {
							# Notification daemon
							swaync = lib.mkIf cfg.notifications.enable {
								enable = true;
							};

							# Clipboard manager
							cliphist = lib.mkIf cfg.utilities.enable {
								enable = true;
							};

							# Udiskie for automatic disk mounting
							udiskie = lib.mkIf cfg.utilities.enable {
								enable = true;
								tray = "auto";
							};

							# Blueman applet
							blueman-applet = lib.mkIf cfg.utilities.enable {
								enable = true;
							};

							# Network manager applet
							network-manager-applet = lib.mkIf cfg.utilities.enable {
								enable = true;
							};
						};

						# XDG configuration
						xdg.configFile = lib.mkIf cfg.wallpaper.enable (
							if cfg.wallpaper.backend == "hyprpaper" then {
								"hypr/hyprpaper.conf".text = ''
									preload = ~/Pictures/wallpaper.png
									wallpaper = ,~/Pictures/wallpaper.png
								'';
							} else {}
						);
					};
				};

			# Standalone package for testing
			packages.${system} = {
				default = pkgs.buildEnv {
					name = "dots-hyprland-env";
					paths = with pkgs; [
						hyprland
						ags
						swww
						rofi-wayland
						hyprlock
						swaynotificationcenter
						grim
						slurp
						wl-clipboard
						cliphist
						brightnessctl
						playerctl
						foot
						kitty
						xdg-utils
						gtk3
						libnotify
					];
				};
			};
		};
}
