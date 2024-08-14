{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gobject-introspection,
  setuptools,
  networkmanager,
  proton-vpn-api-core,
  proton-vpn-killswitch,
  proton-vpn-logger,
  pycairo,
  pygobject3,
  pytestCheckHook,
  iproute2,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "proton-vpn-killswitch-network-manager-wireguard";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-killswitch-network-manager-wireguard";
    rev = "v${version}";
    hash = "sha256-Ftqab+OVh7rK9l1A3KmP7gXLztiCaayB16cmqTTou4g=";
  };

  nativeBuildInputs = [
    # Solves ImportError: cannot import name NM, introspection typelib not found
    gobject-introspection
    setuptools
  ];

  propagatedBuildInputs = [
    # Needed here for the NM namespace
    networkmanager
    proton-vpn-api-core
    proton-vpn-killswitch
    proton-vpn-logger
    pycairo
    pygobject3
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=proton.vpn.killswitch.backend.linux.wireguard --cov-report=html --cov-report=term" ""

    substituteInPlace proton/vpn/killswitch/backend/linux/wireguard/killswitch_connection_handler.py \
      --replace '/usr/sbin/ip' '${iproute2}/bin/ip'
  '';

  pythonImportsCheck = [ "proton.vpn.killswitch.backend.linux.wireguard" ];

  nativeCheckInputs = [ pytestCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Implementation of the proton-vpn-killswitch interface using Network Manager with wireguard-protocol";
    homepage = "https://github.com/ProtonVPN/proton-vpn-killswitch-network-manager-wireguard";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
