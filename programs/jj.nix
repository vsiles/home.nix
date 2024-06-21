{ config, pkgs, name, email, ... }: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        inherit name email;
      };
    };
  };
}
