self: super:
let
  sourceInfo = import ./sources/clawdis-source.nix;
  clawdisGateway = super.callPackage ./packages/clawdis-gateway.nix {
    inherit sourceInfo;
  };
  clawdisSetup = super.callPackage ./packages/clawdis-setup.nix { };
  clawdisDoctor = super.callPackage ./packages/clawdis-doctor.nix { };
in {
  clawdis-gateway = clawdisGateway;
  clawdis-setup = clawdisSetup;
  clawdis-doctor = clawdisDoctor;
}
