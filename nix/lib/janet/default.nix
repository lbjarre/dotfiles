{
  lib,
  stdenv,
  janet,
  jpm,
  runCommandLocal,
}:
let
  /**
    Derviation for a helper to convert lockfile.jdn dependencies into nix code.
  */
  parseLockfileDrv = stdenv.mkDerivation {
    name = "janet-parse-lockfile";
    buildInputs = [
      janet
      jpm
    ];

    src = lib.fileset.toSource {
      root = ./.;
      fileset = ./parse-lockfile.janet;
    };

    buildPhase = ''
      jpm quickbin $src/parse-lockfile.janet parse-lockfile
    '';

    installPhase = ''
      mkdir -p $out/bin
      mv parse-lockfile $out/bin/$name
      chmod +x $out/bin/$name
    '';
  };

  /**
    parseLockfile calls the parseLockfileDrv helper on the given source tree,
    generating a nix file with the parsed dependencies.
  */
  parseLockfile =
    src:
    runCommandLocal "deps.nix"
      {
        inherit src;
        buildInputs = [ parseLockfileDrv ];
      }
      ''
        janet-parse-lockfile $src $out
      '';

  /**
    buildJanetApp compiles a jpm Janet application.
  */
  buildJanetApp =
    {
      name,
      src,
      bin,
      buildInputs ? [ ],
    }:
    stdenv.mkDerivation {
      inherit
        name
        src
        bin
        ;

      buildInputs = buildInputs ++ [
        janet
        jpm
      ];

      deps = map fetchGit (import (parseLockfile src));

      buildPhase = ''
        export JANET_PATH="$PWD/.jpm"
        export JANET_TREE="$JANET_PATH/jpm_tree"
        export JANET_LIBPATH=${janet}/lib
        export JANET_HEADERPATH=${janet}/include/janet
        export JANET_BUILDPATH="$JANET_PATH/build"

        mkdir -p "$JANET_TREE"
        mkdir -p "$JANET_BUILDPATH"

        mkdir -p "$PWD/.deps"
        for dep in $deps; do
          cp -r "$dep" "$PWD/.deps"
        done
        chmod +w -R "$PWD/.deps"
        for dep in "$PWD/.deps/"*; do
          pushd "$dep"
          jpm install
          popd
        done

        jpm build
        jpm install
      '';

      installPhase = ''
        mkdir -p "$out/bin"
        mv "$JANET_TREE/bin/$bin" "$out/bin/$name"
        chmod +x "$out/bin/$name"
      '';
    };
in
{
  packages.default = buildJanetApp;
}
