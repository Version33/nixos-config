{
	description = "My first flake.";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		lanzaboote = {
			url = "github:nix-community/lanzaboote/v0.4.2";
			# Recommended to limit the size of your system closure.
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, ... }@inputs:
	let
		secureBootEnabled = true;

		system = "x86_64-linux";
		lib = nixpkgs.lib;
	in
	{
		nixosConfigurations = {
		# Change 'nixos' to your actual hostname if needed
			nixos = lib.nixosSystem {
				specialArgs = { inherit inputs system; };
				modules = [
					./configuration.nix
					inputs.home-manager.nixosModules.default

				] ++ (lib.optionals secureBootEnabled [
					# If secureBootEnabled is true, these two modules will be imported.
					inputs.lanzaboote.nixosModules.lanzaboote
					./secure-boot.nix
				]);
			};
		};
	};
}
