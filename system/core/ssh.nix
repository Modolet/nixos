_: {
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
      PermitEmptyPasswords = false;
      PubkeyAuthentication = true;
      X11Forwarding = true;
    };
  };
}
