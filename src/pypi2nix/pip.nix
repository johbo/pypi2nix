{ requirementsFile
, cache ? "$out/cache"
, extraBuildInputs ? []
}:

let

  pkgs = import <nixpkgs> {};
  pypi2nix_bootstrap = import ./bootstrap.nix {
    inherit (pkgs) stdenv fetchurl unzip which makeWrapper python;
  };

in pkgs.stdenv.mkDerivation rec {
  name = "pypi2nix-pip";
  __noChroot = true;

  buildInputs = [
    pypi2nix_bootstrap pkgs.unzip
  ] ++ (map (name: builtins.getAttr name pkgs) extraBuildInputs);

  buildCommand = ''
    unset http_proxy
    unset https_proxy
    unset ftp_proxy

    mkdir -p ${cache} $out/wheelhouse

    export PYTHONPATH=${pypi2nix_bootstrap}/base

    PYTHONPATH=${pypi2nix_bootstrap}/extra:$PYTHONPATH pip wheel -r ${requirementsFile} --wheel-dir ${cache} --find-links ${cache}
    PYTHONPATH=${pypi2nix_bootstrap}/extra:$PYTHONPATH pip freeze > $out/requirements.txt

    cd $out/wheelhouse
    for file in ${cache}/*; do
      unzip -qo $file
    done
  '';
}
