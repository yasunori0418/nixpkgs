{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  proton-core,
  proton-vpn-connection,
  proton-vpn-logger,
  proton-vpn-killswitch,
  proton-vpn-session,
  sentry-sdk,
  distro,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "proton-vpn-api-core";
  version = "0.30.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-api-core";
    rev = "v${version}";
    hash = "sha256-AoI7B/Z7wQNNRVqtapZnsyczmd/9aUj9KD1ixD+5yhE=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    distro
    proton-core
    proton-vpn-connection
    proton-vpn-logger
    proton-vpn-killswitch
    proton-vpn-session
    sentry-sdk
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--cov=proton/vpn/core/ --cov-report html --cov-report term" ""
  '';

  pythonImportsCheck = [ "proton.vpn.core" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Permission denied: '/run'
    "test_ensure_configuration_file_is_created"
    "test_ovpnconfig_with_settings"
    "test_wireguard_config_content_generation"
    "test_wireguard_with_non_certificate"
    "test_ensure_generate_is_returning_expected_content"
    "test_ensure_same_configuration_file_in_case_of_duplicate"
    "test_ensure_configuration_file_is_deleted"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Acts as a facade to the other Proton VPN components, exposing a uniform API to the available Proton VPN services";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-api-core";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
