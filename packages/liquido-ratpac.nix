{ lib, stdenv, cmake, pkg-config, makeWrapper, fetchFromGitHub, geant4, root, fftw }:

stdenv.mkDerivation {
  pname = "liquido-ratpac";
  version = "26-09";

  src = fetchFromGitHub {
    owner = "liquid-o";
    repo = "ratpac-two";
    rev = "0454bff29ccc29f7ad05a0f1e5b2ddaa77ce77de";
    sha256 = "sha256-hfY2cr2gGW9h98OsyRGMeX3DpiRApwTtrY8sPvWAAJ8=";
  };

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];
  buildInputs = [ geant4
                  geant4.data.G4ENSDFSTATE
                  geant4.data.G4NDL
                  geant4.data.G4EMLOW
                  geant4.data.G4PhotonEvaporation
                  geant4.data.G4RadioactiveDecay
                  geant4.data.G4PARTICLEXS
                  geant4.data.G4RealSurface
                  geant4.data.G4SAIDDATA
                  root
                  fftw
                ];

  setupHook = ./ratpac-setup-hook.sh;

  patches = [../patches/waveformutil-limits.patch];

  postInstall = ''
    wrapProgram $out/bin/rat \
    --set RATSHARE "$out/share/RAT" \
    --set G4ENSDFSTATEDATA "$(echo ${geant4.data.G4ENSDFSTATE}/share/Geant4-*/data/G4ENSDFSTATE*)" \
    --set G4NEUTRONHPDATA "$(echo ${geant4.data.G4NDL}/share/Geant4-*/data/G4NDL*)" \
    --set G4LEDATA "$(echo ${geant4.data.G4EMLOW}/share/Geant4-*/data/G4EMLOW*)" \
    --set G4LEVELGAMMADATA "$(echo ${geant4.data.G4PhotonEvaporation}/share/Geant4-*/data/G4PhotonEvaporation*)" \
    --set G4RADIOACTIVEDATA "$(echo ${geant4.data.G4RadioactiveDecay}/share/Geant4-*/data/G4RadioactiveDecay*)" \
    --set G4PARTICLEXSDATA "$(echo ${geant4.data.G4PARTICLEXS}/share/Geant4-*/data/G4PARTICLEXS*)" \
    --set G4REALSURFACEDATA "$(echo ${geant4.data.G4RealSurface}/share/Geant4-*/data/G4RealSurface*)" \
    --set G4SAIDXSDATA "$(echo ${geant4.data.G4SAIDDATA}/share/Geant4-*/data/G4SAIDDATA*)"
  '';
  
  meta = {
    description = "Simulation and analysis package built on GEANT4 and ROOT with LiquidO additions";
    homepage = "https://github.com/liquid-o/ratpac-two";
    mainProgram = "rat";
  };
}
