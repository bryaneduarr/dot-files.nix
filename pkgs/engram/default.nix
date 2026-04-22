{
  stdenvNoCC,
  fetchurl,
  lib,
}:
let
  release = builtins.fromJSON (builtins.readFile ./release.json);
  system = stdenvNoCC.hostPlatform.system;
  asset =
    release.platforms.${system}
      or (throw "engram is not packaged for ${system} in pkgs/engram/release.json");
in
stdenvNoCC.mkDerivation {
  pname = "engram";
  version = release.version;

  src = fetchurl {
    url = asset.url;
    hash = asset.hash;
  };

  dontConfigure = true;
  dontBuild = true;
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 engram "$out/bin/engram"
    runHook postInstall
  '';

  meta = {
    description = "Persistent memory for AI coding agents";
    homepage = "https://github.com/Gentleman-Programming/engram";
    license = lib.licenses.mit;
    mainProgram = "engram";
    platforms = builtins.attrNames release.platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
