{ username, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.settings.trusted-users = [ username ];

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 1;
      Hour = 8;
      Minute = 30;
    };
    options = "--delete-older-than 10d";
  };
  nix.settings.auto-optimise-store = true;

  # if having error mentioning linux, you might need a linux vm setup.
  # First step, uncomment the next line and run ./install
  # nix.linux-builder.enable = true;
  # Second set is to replace it with the following block and run ./install again
  # nix.linux-builder = {
  #   enable = true;
  #   config = {
  #     virtualisation.darwin-builder.memorySize = 8192;
  #     virtualisation.darwin-builder.diskSize = 65536;
  #     networking.firewall.enable = false;
  #     virtualisation.sharedDirectories.sharedHome = {
  #       source = "/Users/Shared";
  #       target = "/Users/Shared";
  #     };
  #     virtualisation.cores = 6;
  #   };
  # };

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # You can find all configuration options here:
  # <https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.enable>
  homebrew = {
    enable = true;
    # caskArgs.no_quarantine = true;
    # TODO(vsiles) understand these two, not sure I need them
    # global.brewfile = true;
    # global.autoUpdate = false;
    masApps = { };
    casks = import ./homebrew/casks.nix;
    brews = import ./homebrew/brews.nix;
  };

  # Used for backwards compatibility, please read the nix-darwin changelog before changing
  # w/ darwin-rebuild changelog.
  system.stateVersion = 4;
}
