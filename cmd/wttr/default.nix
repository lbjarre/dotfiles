{
  lib,
  buildJanetApp,
  curl,
}:
buildJanetApp {
  name = "wttr";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.fileFilter (file: file.hasExt "janet" || file.hasExt "jdn") ./.;
  };
  bin = "wttr";
  buildInputs = [ curl ];
}
