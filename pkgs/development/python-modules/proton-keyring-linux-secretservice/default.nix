{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  proton-keyring-linux,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "proton-keyring-linux-secretservice";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-keyring-linux-secretservice";
    rev = "refs/tags/v${version}";
    hash = "sha256-IZPT2bL/1YD2TH/djwIQHUE1RRbYMTkQDacjjoqDQWo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ proton-keyring-linux ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--cov=proton.keyring_linux.secretservice --cov-report html --cov-report term" ""
  '';

  pythonImportsCheck = [ "proton.keyring_linux" ];

  nativeCheckInputs = [ pytestCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ProtonVPN component to access Linux's keyring secret service API";
    homepage = "https://github.com/ProtonVPN/python-proton-keyring-linux-secretservice";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
