{ stdenvNoCC, lib, wine, yabridge, requireFile }:
let
	_version = "2.0.22";

serum2 = requireFile {
	name = "Install_Xfer_Serum2_${_version}.exe";
	sha256 = "09f7lplg4md58sq5b6a3lwp6nvaw4333lnhr314rwlk4ar1xrbr6";
	# You must be logged in to your Xfer Records account for this URL to work.
	url = "https://xferrecords.com/product_downloads/serum-2-0-22-for-windows/start";
};

in
	stdenvNoCC.mkDerivation rec {
	pname = "serum2";
	version = _version;
	src = serum2;
	dontUnpack = true;
	nativeBuildInputs = [ wine yabridge ];
	installPhase = ''
		runHook preInstall

		export HOME=$PWD
		export WINEPREFIX=$PWD/wineprefix

		# --- FIX ---
		# Wrap wine commands with xvfb-run to provide a virtual display
		xvfb-run wineboot -u
		xvfb-run wine $src /S &

		# Wait for the installer to finish.
		# Note: sleep is not perfectly reliable. If the install fails, you may need to increase this value.
		sleep 15

		local vst3_path="$WINEPREFIX/drive_c/Program Files/Common Files/VST3/Serum.vst3"

		if [ ! -d "$vst3_path" ]; then
			echo "Error: Serum.vst3 not found at $vst3_path after installation!"
			echo "The silent installation may have failed."
			# Added for easier debugging if it fails again
			echo "--- Listing C:/Program Files/Common Files ---"
			ls -la "$WINEPREFIX/drive_c/Program Files/Common Files" || echo "Directory not found."
			exit 1
		fi

		yabridgectl add "$vst3_path"
		yabridgectl sync

		mkdir -p $out/lib/vst3
		cp -r "$HOME/.vst3/yabridge/Serum.vst3" "$out/lib/vst3/"

		runHook postInstall
  	'';

	meta = with lib; {
		description = "Advanced Wavetable Synthesizer by Xfer Records (via Yabridge)";
		homepage = "https://xferrecords.com/products/serum";
		license = licenses.unfree;
		platforms = [ "x86_64-linux" ];
	};
}