{ config
, pkgs
, ...
}: {
  programs.fzf = {
    # TODO: read more about fzf's config
    enable = true;
    enableFishIntegration = true;
  };
}
