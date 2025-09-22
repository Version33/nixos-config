{
description = "A flake for Lanzaboote Secure Boot configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
	};

	outputs = { self, nixpkgs, lanzaboote }: {
		# This flake's output is a single, self-contained NixOS module.
		nixosModules.default = { pkgs, lib, ... }: {
			imports = [
				lanzaboote.nixosModules.lanzaboote
			];

			environment.systemPackages = [
				pkgs.sbctl
			];

			boot.loader.systemd-boot.enable = lib.mkForce false;

			boot.lanzaboote = {
				enable = true;
				pkiBundle = "/var/lib/sbctl";
			};
		};
	};
}
