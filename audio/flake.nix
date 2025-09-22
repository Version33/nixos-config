{
	description = "A flake for all my audio production software and VSTs";

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

			# 1. Define all your VST packages here using callPackage
			serum2 = pkgs.callPackage ./plugins/serum2.nix {};

		in
		{
			# 2. Expose the combined environment as the default package
			packages.${system}.default = pkgs.buildEnv {
				name = "vst-plugin-env";
				paths = [
					# List all your VSTs here
					serum2

					# You can also include VSTs from nixpkgs directly
					pkgs.vital
					pkgs.surge
					pkgs.cardinal
				];
			};
			serum2 = serum2;
		};
}