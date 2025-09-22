{ inputs, config, pkgs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
			./hardware-configuration.nix
			./unfree.nix
			inputs.home-manager.nixosModules.default
		];

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};

	home-manager = {
		extraSpecialArgs = { inherit inputs; };
		users = {
		vee = import ./home.nix;
		};
		useGlobalPkgs = true;
	};

	# Use latest kernel.
	boot.kernelPackages = pkgs.linuxPackages_latest;

	networking.hostName = "nixos"; # Define your hostname.
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

	# Enable networking
	networking.networkmanager.enable = true;

	# Set your time zone.
	time.timeZone = "America/New_York";

	# Enable the X11 windowing system.
	# You can disable this if you're only using the Wayland session.
	services.xserver.enable = true;

	# Enable the KDE Plasma Desktop Environment.
	services.displayManager.sddm.enable = true;
	services.desktopManager.plasma6.enable = true;

	# Configure keymap in X11
	services.xserver.xkb = {
		layout = "us";
		variant = "";
	};

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

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.vee = {
		isNormalUser = true;
		description = "Vee";
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [
			kdePackages.kate
			home-manager
		];
		shell = pkgs.nushell;
	};

	environment.shells = [
		"/run/current-system/sw/bin/nu"
		"${pkgs.zsh}/bin/nu"
	];

	# Install Programs
	programs = {
		steam = {
			enable = true;
			package = pkgs.steam.override {
				extraPkgs = p: [
					p.kdePackages.breeze # cursor fix
				];
			};
		};
	};

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		wget
		neovim
		gtop
		usbutils
		gparted
	];

	hardware.opentabletdriver.enable = true;

#   xdg.icons.fallbackCursorThemes = [ "breeze_cursors" ];

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	# services.openssh.enable = true;

	# before changing, double check with
	# `man configuration.nix` or on `https://nixos.org/nixos/options.html`
	system.stateVersion = "25.05"; # Probably never change this.

	nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
