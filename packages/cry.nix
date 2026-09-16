{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "cry";
  version = "1.7";

  src = fetchurl {
    url = "http://nuclear.llnl.gov/simulation/cry_v${version}.tar.gz";
    sha256 = "080cawzfv6q55k4banhfafwg9gw59lpw9iz0h8zi3fhwz0l29vnw"; # found with `nix-prefetch-url <url>`
  };

  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib $out/include $out/share/cry/data $out/nix-support
    cp lib/libCRY.a   $out/lib/
    cp src/*.h        $out/include/
    cp -r data/*      $out/share/cry/data/

    echo "export CRYDATA=\"$out/share/cry/data\"" > $out/nix-support/setup-hook
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "LLNL Cosmic-ray Shower Library (CRY)";
    homepage = "https://nuclear.llnl.gov/simulation/";
    platforms = platforms.unix;
  };
}
