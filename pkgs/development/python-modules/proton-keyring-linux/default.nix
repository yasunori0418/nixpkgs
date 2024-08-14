{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  keyring,
  proton-core,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "proton-keyring-linux";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-keyring-linux";
    rev = "refs/tags/v${version}";
    hash = "sha256-c2wdbd8Hkz2hF9zYMy4/V/W6uZRItz7tWqLJqTsJoHU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    keyring
    proton-core
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--cov=proton.keyring_linux.core --cov-report html --cov-report term" ""
  '';

  pythonImportsCheck = [ "proton.keyring_linux.core" ];

  nativeCheckInputs = [ pytestCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ProtonVPN core component to access Linux's keyring";
    homepage = "https://github.com/ProtonVPN/python-proton-keyring-linux";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
