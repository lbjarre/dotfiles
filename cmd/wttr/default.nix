{
  lib,
  buildJanetApp,
  openssl_3,
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
  buildInputs = [ openssl_3 ];
}
