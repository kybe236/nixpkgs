{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  babel,
  hatchling,
  setuptools,

  # dependencies
  markupsafe,

  # optional-dependencies
  email-validator,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "wtforms";
  version = "3.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "wtforms";
    tag = finalAttrs.version;
    hash = "sha256-4UmvzAcEt+dsXLGfAHgG/uN4QEh9uQvMgrjWJn65wIE=";
  };

  build-system = [
    babel
    hatchling
    setuptools
  ];

  dependencies = [ markupsafe ];

  optional-dependencies = {
    email = [ email-validator ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "wtforms" ];

  meta = {
    description = "Flexible forms validation and rendering library for Python";
    homepage = "https://github.com/pallets-eco/wtforms";
    changelog = "https://github.com/pallets-eco/wtforms/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
  };
})
