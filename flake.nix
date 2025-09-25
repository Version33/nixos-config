{
	description = "Main system flake.";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		lanzaboote = {
			url = "github:nix-community/lanzaboote/v0.4.2";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		secure-boot = { # And used here
			url = "path:./secure-boot";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.lanzaboote.follows = "lanzaboote";
		};
		audio.url = "path:./audio";
	};

	outputs = { self, nixpkgs, ... }@inputs:
	let
		secureBootEnabled = true;

		system = "x86_64-linux";
		lib = nixpkgs.lib;
	in
	{
		nixosConfigurations = {
			nixos = lib.nixosSystem {
				specialArgs = { inherit inputs system; };
				modules = [
					./configuration.nix
					inputs.home-manager.nixosModules.default
					inputs.secure-boot.nixosModules.default
				];
			};
		};
	};
}
