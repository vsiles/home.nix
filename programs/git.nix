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
    delta = {
      enable = true;

      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
          hunk-header-decoration-style = "cyan box ul";
        };

        line-numbers = {
          line-numbers-left-style = "cyan";
          line-numbers-minus-style = "bold 124";
          line-numbers-plus-style = "bold 28";
          line-numbers-right-style = "cyan";
        };

        features = "line-numbers decorations";
        # line-numbers = true;
        minus-style = ''syntax "#3f0001"'';
        plus-emph-style = ''syntax "#005600"'';
        plus-style = ''syntax "#002300"'';
        side-by-side = true;
        syntax-theme = "Coldark-Dark";
        # syntax-theme = "Dracula";
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
