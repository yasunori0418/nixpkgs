{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gobject-introspection,
  setuptools,
  proton-core,
  proton-vpn-killswitch-network-manager-wireguard,
  proton-vpn-network-manager,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "proton-vpn-network-manager-wireguard";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-network-manager-wireguard";
    rev = "v${version}";
    hash = "sha256-ta3PrggudGTpf7bdMk0Djw903Dw6Ji0vXl42bc6QGmk=";
  };

  nativeBuildInputs = [
    # Solves Namespace NM not available
    gobject-introspection
    setuptools
  ];

  propagatedBuildInputs = [
    proton-core
    proton-vpn-killswitch-network-manager-wireguard
    proton-vpn-network-manager
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--cov=proton.vpn.backend.linux.networkmanager.protocol.wireguard --cov-report html --cov-report term" ""
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Adds support for the Wireguard protocol using NetworkManager";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-network-manager-wireguard";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
