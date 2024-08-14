{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  proton-core,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "proton-vpn-killswitch";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-killswitch";
    rev = "v${version}";
    hash = "sha256-XZqjAhxgIiATJd3JcW2WWUMC1b6+cfZRhXlIPyMUFH8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ proton-core ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--cov=proton --cov-report=html --cov-report=term" ""
  '';

  pythonImportsCheck = [ "proton.vpn.killswitch.interface" ];

  nativeCheckInputs = [ pytestCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Defines the ProtonVPN kill switch interface";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-killswitch";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
