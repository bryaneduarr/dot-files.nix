{
  buildNpmPackage,
  fetchurl,
  fetchNpmDeps,
  lib,
}:
let
  release = builtins.fromJSON (builtins.readFile ./release.json);
in
buildNpmPackage {
  pname = "engram";
  version = release.version;

  src = fetchurl {
    url = "https://registry.npmjs.org/gentle-engram/-/gentle-engram-${release.version}.tgz";
    hash = release.srcHash;
  };

  npmDeps = fetchNpmDeps {
    src = ./.;
    hash = release.npmDepsHash;
  };

  npmInstallFlags = [ "--production" ];

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  meta = {
    description = "Persistent memory for Pi agents";
    homepage = "https://github.com/Gentleman-Programming/engram";
    license = lib.licenses.mit;
    mainProgram = "pi-engram";
    platforms = lib.platforms.all;
  };
}
