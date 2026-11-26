{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  npmHooks,
  versionCheckHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "taze";
  version = "21.2.0";

  src = fetchFromGitHub {
    owner = "made-in-common";
    repo = "taze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-raAtOH9fVaN8BuQASXailJLMWKUKi0zhZ+/rECcgAQo=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-aML7uHmW3JWYkCaZnQV1OnVWiueQZ3ilT9KH6l6vGJA=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_11
    npmHooks.npmInstallHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build
    find dist -type f \( -name '*.cjs' -or -name '*.cts' -or -name '*.ts' \) -delete

    runHook postBuild
  '';

  preInstall = ''
    # Prune deps before installing to save space
    CI=true pnpm prune --prod --ignore-scripts
    # Clean up broken symlinks left behind by `pnpm prune`
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules -xtype l -delete
  '';

  dontNpmPrune = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern cli tool that keeps your deps fresh";
    homepage = "https://github.com/made-in-common/taze";
    changelog = "https://github.com/made-in-common/taze/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "taze";
  };
})
