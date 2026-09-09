{
  lib,
  buildJanetApp,
  openssl,
}:
buildJanetApp {
  name = "wttr";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./main.janet
      ./project.janet
      ./lockfile.jdn
    ];
  };
  bin = "wttr";
  buildInputs = [ openssl ];
}
