# Fetches a docset for the Fennel language server to understand nvim modules.
#
# Docs: https://dev.fennel-lang.org/wiki/LanguageServer
{ fetchgit }:
let
  src = fetchgit {
    url = "https://git.sr.ht/~micampe/fennel-ls-nvim-docs";
    rev = "8d354237295c5d14e2b560ad73737a2e15550f19";
    hash = "sha256-H9EnwkgkLADx+5Xkr8OiZVBQuZR2+yuUsq8zIa7s8aY=";
    sparseCheckout = [ "nvim.lua" ];
  };
in
"${src}/nvim.lua"
