{ config, pkgs, ... }:

{
	# Home Manager needs a bit of information about you and the paths it should
	# manage.
	home.username = "vee";
	home.homeDirectory = "/home/vee";

	# This value determines the Home Manager release that your configuration is
	# compatible with. This helps avoid breakage when a new Home Manager release
	# introduces backwards incompatible changes.
	#
	# You should not change this value, even if you update Home Manager. If you do
	# want to update the value, then make sure to first check the Home Manager
	# release notes.
	home.stateVersion = "24.11"; # Please read the comment before changing.

	# The home.packages option allows you to install Nix packages into your
	# environment.
	home.packages = with pkgs; [
		osu-lazer-bin
		tidal-hifi
		discord
		bitwig-studio
		proton-pass
		kdePackages.filelight
		qimgv
		orca-slicer
	];

	home.shell.enableNushellIntegration = true;
	programs.starship.enableNushellIntegration = true;

	programs = {
		fastfetch.enable = true;
		obs-studio.enable = true;
		firefox.enable = true;

		vscode = {
			enable = true;
			profiles.default = {
			extensions = with pkgs.vscode-extensions; [
				vscodevim.vim
				visualstudioexptteam.vscodeintellicode
				christian-kohler.path-intellisense
					jnoortheen.nix-ide
			];
			};
		};

		git = {
			enable = true;
			userName = "Version33";
			userEmail = "vee@versionthirtythr.ee";
			aliases = {
				pu = "push";
				co = "checkout";
				cm = "commit";
			};
			extraConfig = {
				init.defaultBranch = "main";
				safe.directory = "/etc/nixos";
			};
		};

		nushell = {
			enable = true;
			shellAliases = {
				nix-shell = "nix-shell --command nu";
			};
			settings = {
				show_banner = false;
			};
			configFile.text = "fastfetch";
		};
		starship = {
			enable = true;
		};
	};

	# Home Manager is pretty good at managing dotfiles. The primary way to manage
	# plain files is through 'home.file'.
	home.file = {
		# # Building this configuration will create a copy of 'dotfiles/screenrc' in
		# # the Nix store. Activating the configuration will then make '~/.screenrc' a
		# # symlink to the Nix store copy.
		# ".screenrc".source = dotfiles/screenrc;

		# # You can also set the file content immediately.
		# ".gradle/gradle.properties".text = ''
		#   org.gradle.console=verbose
		#   org.gradle.daemon.idletimeout=3600000
		# '';
	};

	# Home Manager can also manage your environment variables through
	# 'home.sessionVariables'. These will be explicitly sourced when using a
	# shell provided by Home Manager. If you don't want to manage your shell
	# through Home Manager then you have to manually source 'hm-session-vars.sh'
	# located at either
	#
	#  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
	#
	# or
	#
	#  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
	#
	# or
	#
	#  /etc/profiles/per-user/vee/etc/profile.d/hm-session-vars.sh
	#
	home.sessionVariables = {
		EDITOR = "nvim";
	};

	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
}
