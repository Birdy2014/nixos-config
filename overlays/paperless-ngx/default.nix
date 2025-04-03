final: prev: {
  paperless-ngx = prev.paperless-ngx.overrideAttrs (attrs:
    let
      extraPythonPackages =
        (with prev.paperless-ngx.python.pkgs; [ django-auth-ldap python-ldap ]);
    in {
      # Workaround for https://github.com/NixOS/nixpkgs/issues/361006
      doInstallCheck = false;

      propagatedBuildInputs = attrs.propagatedBuildInputs
        ++ extraPythonPackages;

      postInstall = let
        pythonPkgs = prev.paperless-ngx.python.pkgs;
        extraPythonPath = pythonPkgs.makePythonPath extraPythonPackages;
      in ''
        cp ${
          ./settings_ldap.py
        } $out/lib/paperless-ngx/src/paperless/settings_ldap.py

        wrapProgram $out/bin/paperless-ngx \
          --prefix PYTHONPATH : "${extraPythonPath}"
        wrapProgram $out/bin/celery \
          --prefix PYTHONPATH : "${extraPythonPath}"
      '';
    });
}
