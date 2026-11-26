{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "fenrir";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LeviathanXCDN";
    repo = "fenrirlvx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vwwNKt8GsX2+Ik9G7dungXNYIZ2LZZ/J+Qt/0yVvxvo=";
  };

  vendorHash = "sha256-2rA0Z33J8R5KMZ/NQ25Eww0NUia8oDZvOCGqgqQthkQ=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-X=github.com/leviathan-offsec/FenrirLVX/cmd.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/FenrirLVX $out/bin/$pname
  '';

  doInstallCheck = true;

  versionCheckProgramArg = [ "version" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for WordPress attack surface mapping, plugin fingerprinting, and offline CVE correlation";
    homepage = "https://github.com/LeviathanXCDN/FenrirLVX";
    changelog = "https://github.com/LeviathanXCDN/FenrirLVX/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "fenrir";
  };
})
