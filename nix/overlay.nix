self: super:
let
  sourceInfo = import ./sources/clawdbot-source.nix;
  clawdbotGateway = super.callPackage ./packages/clawdbot-gateway.nix {
    inherit sourceInfo;
  };
  clawdbotApp = super.callPackage ./packages/clawdbot-app.nix { };
  toolSets = import ./tools/extended.nix { pkgs = super; };
  clawdbotToolsBase = super.buildEnv {
    name = "clawdbot-tools-base";
    paths = toolSets.base;
  };
  clawdbotToolsExtended = super.buildEnv {
    name = "clawdbot-tools-extended";
    paths = toolSets.extended;
  };
  clawdbotBundle = super.callPackage ./packages/clawdbot-batteries.nix {
    clawdbot-gateway = clawdbotGateway;
    clawdbot-app = clawdbotApp;
    extendedTools = toolSets.base;
  };
in {
  clawdbot-gateway = clawdbotGateway;
  clawdbot-app = clawdbotApp;
  clawdbot = clawdbotBundle;
  clawdbot-tools-base = clawdbotToolsBase;
  clawdbot-tools-extended = clawdbotToolsExtended;
}
