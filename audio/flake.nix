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

			serum2 = pkgs.callPackage ./plugins/serum2.nix {};

			windowsPlugins = [
				serum2
				# anotherVst
			];

			windowsPluginBundle = pkgs.runCommand "windows-plugin-bundle" {} ''
				mkdir -p $out
				${pkgs.lib.concatMapStringsSep "\n" (plugin: ''
          			ln -s ${plugin}/* $out/
        		'') windowsPlugins}
      		'';


		in
		{
			packages.${system} = {
				inherit windowsPluginBundle;
				inherit serum2;

				default = pkgs.buildEnv {
					name = "vst-plugin-env";
					paths = [
						pkgs.bitwig-studio

						pkgs.yabridge
						pkgs.yabridgectl
						pkgs.wine-staging
						pkgs.winetricks


						pkgs.vital
						pkgs.surge
						pkgs.cardinal
					];
				};
			};

			
		};
}
