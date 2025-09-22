{config, lib, pkgs, ...}:
{
	# Unfree packages to allow.
	nixpkgs.config.allowUnfreePredicate = pkg:
		builtins.elem (lib.getName pkg) [
			"castlabs-electron"
			"steam"
			"steam-unwrapped"
			"discord"
			"bitwig-studio-unwrapped"
			"osu-lazer-bin"
			"code"
			"vscode"
		];
}
