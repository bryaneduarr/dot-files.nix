{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true; # Enable ZSH here too, it is also enabled in the 'configuration.nix' file.

    history = {
      size = 10000; # Limit of history.
      save = 10000; # Limit of history.
      path = "${config.home.homeDirectory}/.zsh_history"; # The directory will be created automatically by home-manager.

      # setopt APPEND_HISTORY.
      append = true;

      # setopt HIST_IGNORE_DUPS.
      ignoreDups = true;
      
      # setopt HIST_IGNORE_ALL_DUPS.
      ignoreAllDups = true;

      # setopt HIST_SAVE_NO_DUPS.
      saveNoDups = true;

      # setopt HIST_FIND_NO_DUPS.
      findNoDups = true;

      # setopt HIST_IGNORE_SPACE.
      ignoreSpace = true;

      # setopt HIST_EXPIRE_DUPS_FIRST.
      expireDuplicatesFirst = true;

      # setopt SHARE_HISTORY.
      share = true;

      # unsetopt EXTENDED_HISTORY
      extended = false;
    };

    # All of the plugins will be managed by 'zplug'.
    zplug = {
      enable = true; # Enable zplug.

      # Place all of the plugins for ZSH in here.
      plugins = [
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "jeffreytse/zsh-vi-mode"; }
        { name = "romkatv/powerlevel10k"; tags = [ "as:theme" "depth:1" ]; }
	      { name = "zsh-users/zsh-completions"; }
	      { name = "zsh-users/zsh-autosuggestions"; }
	      { name = "Aloxaf/fzf-tab"; }
      ];
    };
  
    # Inline shell customizations (functions, exports, prompts, etc.).
    initContent = ''
      # Function to update and rebuild the system using flakes.
      update() {
        sudo nixos-rebuild switch --flake ~/nix-config/#nixos "$@"
      }
  
      # Set the default editor to Neovim.
      export EDITOR=nvim

      # Preview directories for `cd` with eza tree and colors.
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --color=always --level=2 $realpath'

      
      # Preview files for a list of commands using bat.
      # The pattern  in here will match any of the commands listed.
      zstyle ':(fzf-tab:complete:nvim:*|fzf-tab:complete:nano:*|fzf-tab:complete:cat:*|fzf-tab:complete:bat:*|fzf-tab:complete:less:*)' fzf-preview 'bat --color=always --style=numbers,changes --line-range=:500 $realpath'

      # Fzf default handler for the preview and other options.
      export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline"

      # Yazi function to stay in the directory and activate with 'y'.
      y() {
	      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	      yazi "$@" --cwd-file="$tmp"
	      IFS= read -r -d "" cwd < "$tmp"
	      [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	      rm -f -- "$tmp"
      }

      # Source the Powerlevel10k theme and configuration.
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${config.home.homeDirectory}/.p10k.zsh
    '';
  };

  # Make sure the p10k package is available.
  home.packages = [
    pkgs.zsh-powerlevel10k
  ];

  # Tell where the configuration file for p10k is.
  home.file = {
    ".p10k.zsh".source = ./../.p10k.zsh;
  };
}
