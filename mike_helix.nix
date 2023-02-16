self: super:
{
  sl = super.helix.overrideAttrs (old: {
    src = super.fetchFromGitHub {
      owner = "the-mikedavis";
      repo = "helix";
      rev = "bf874868aa9b052a8a795ef9ef1aa0bb34cd6154";
      # If you don't know the hash, the first time, set:
      # sha256 = "0000000000000000000000000000000000000000000000000000";
      # then nix will fail the build with such an error message:
      # hash mismatch in fixed-output derivation '/nix/store/m1ga09c0z1a6n7rj8ky3s31dpgalsn0n-source':
      # wanted: sha256:0000000000000000000000000000000000000000000000000000
      # got:    sha256:173gxk0ymiw94glyjzjizp8bv8g72gwkjhacigd1an09jshdrjb4
      sha256 = "173gxk0ymiw94glyjzjizp8bv8g72gwkjhacigd1an09jshdrjb4";
    };
  });
}
