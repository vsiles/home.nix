{ config, pkgs, lib, actualName, email, ... }:
{
  programs.git = {
    enable = true;
    aliases = {
      s = "status";
      st = "status";
      sl = "log --oneline --all --graph";
      branches = "branch --list 'vsiles/*' develop";
      all-branches = "branch --list --all";
    };
    userName = actualName;
    userEmail = email;
    lfs.enable = true;
    extraConfig = {
      init.defaultBranch = "develop";
      merge = {
        tool = "my_vimdiff";
        conflictstyle = "diff3";
      };
      mergetool = {
        keepBackup = false;
        prompt = false;
        "my_vimdiff".cmd = "nvim -d \"$LOCAL\" \"$MERGED\" \"$BASE\" \"$REMOTE\" -c \"wincmd w\" -c \"wincmd J\"";
      };
    };
  };
}

# Some past configurations
# [mergetool "vimdiff"]
# ; cmd = "nvim  -d $MERGED $LOCAL $BASE $REMOTE -c 'wincmd J | wincmd ='"
# ; script to accept arguments sending in from git mergetool
# ;
# ; Base is $1
# ; Remote (or Theirs) is $2
# ; Local (or Yours) is $3
# ; Merged is $4
#   cmd = nvim -d \"$LOCAL\" \"$MERGED\" \"$BASE\" \"$REMOTE\" -c \"wincmd w\" -c \"wincmd J\"
# ;
# ; or try
# ; git config merge.tool vimdiff
# ; git config merge.conflictstyle diff3
# ; git config mergetool.prompt false
# ;
# ; https://www.rosipov.com/blog/use-vimdiff-as-git-mergetool/
