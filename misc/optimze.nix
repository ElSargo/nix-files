{pkgs,...} : {
let
  extraCflagsFun = pkgs: import (pkgs.runCommand "cflags" {
    preferLocalBuild = true;
    __noChroot = true;
    hashChangingValue = "asdasdasd";
  } ''
    mkdir $out
    echo "" | gcc -O3 -march=native -mtune=native -v -E - 2>&1 |grep cc1 |sed -r 's/.*? - -(.*)$/-\1/' > $out/flags
    echo "builtins.readFile ./flags" > $out/default.nix
  '');

  optimizePackageFun = pkgs: pkg: pkgs.lib.overrideDerivation pkg (attrs: {
    NIX_CFLAGS_COMPILE = "${attrs.NIX_CFLAGS_COMPILE or ""} ${extraCflagsFun pkgs};
  });
in {
  packageOverrides = pkgs:
    let
      optimizePackage = optimizePackageFun pkgs;
    in {
      # This one doesn't override the real package, so anything that depends on vim gets
      # an unoptimized version
      customVim = optimizePackage pkgs.vim;

      # Super-fast command line history for everyone!
      readline = optimizePackage pkgs.readline;
    };
};
}