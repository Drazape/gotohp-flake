{
	description = "Unofficial Google Photos Desktop GUI Client";

	inputs = {
		flake-parts = { type="github"; owner="hercules-ci"; repo="flake-parts"; };
		nixpkgs = { type="github"; owner="NixOS"; repo="nixpkgs"; ref="nixpkgs-unstable"; };
		gotohp = {
			url = "https://github.com/xob0t/gotohp/releases/latest/download/gotohp_amd64.deb";
			flake = false;
		};
	};

	outputs = inputs@{ flake-parts, ... }:
		flake-parts.lib.mkFlake { inherit inputs; } {
			systems = ["x86_64-linux"];
			perSystem = { config, self', inputs', pkgs, system, ... }: {
				packages = let pkgName = "gotohp"; in {
					default = self'.packages.${pkgName};
					${pkgName} = pkgs.stdenv.mkDerivation {
						name = pkgName;
						src = inputs.${pkgName};

						nativeBuildInputs = with pkgs; [ dpkg autoPatchelfHook ];
						buildInputs = with pkgs; [ libX11 webkitgtk_6_0 gtk4 libsoup_3 glib ];

						unpackPhase = ''
								dpkg --extract -- $src ./tree/
								cd ./tree/usr/
						'';

						installPhase = ''
								mkdir -p $out/
								mv ./local/bin/ ./share/ $out/
						'';

						meta = {
							description = "Unofficial Google Photos Desktop GUI Client";
							homepage = "https://github.com/xob0t/"+pkgName;
							license = pkgs.lib.licenses.mit;
							mainProgram = pkgName;
						};
					};
				};
			};
		};
}		 
