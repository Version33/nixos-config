# secure-boot.nix
# This module contains all the necessary settings to enable Lanzaboote for Secure Boot.
# It is only imported by flake.nix when the `secureBootEnabled` flag is set to true.
{ pkgs, lib, ... }: {
	environment.systemPackages = [
		# Provides sbctl for creating and managing Secure Boot keys.
		pkgs.sbctl
	];
	# Lanzaboote currently replaces the systemd-boot module.
	# This setting is usually set to true in configuration.nix
	# generated at installation time. So we force it to false
	# for now.
	boot.loader.systemd-boot.enable = lib.mkForce false;

	# Enable and configure Lanzaboote.
	boot.lanzaboote = {
		enable = true;
		# This tells Lanzaboote to use the keys managed by sbctl.
		# Ensure you have run `sbctl create-keys` before rebooting.
		pkiBundle = "/var/lib/sbctl";
	};
}
