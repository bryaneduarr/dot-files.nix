# Entry point for home-manager configuration for the user.
# This file defines all user-level settings, packages, and program configurations for Ubuntu ARM64 systems.
# It is intended to be imported by the main system configuration to set up the user's environment on ARM64.
{ config, pkgs, ... }:

{
  # Set the username and home directory for home-manager.
  # These values should match the system user created in the main OS configuration. #
  home.username = "bryaneduarr";
  home.homeDirectory = "/home/bryaneduarr";

  # Specify the Home Manager release version compatible with this configuration.
  # This should be updated only when upgrading Home Manager to avoid breaking changes.
  home.stateVersion = "25.05";

  # This allows the user to update their environment independently of the system configuration.
  programs.home-manager.enable = true;

  # List of packages to be installed for the user on Ubuntu x64.
  home.packages = with pkgs; [
    awscli2
    bat
    btop
    bun
    chromium
    cmake
    curl
    eza
    fd
    fzf
    gcc
    git
    gnumake
    lazygit
    nodejs_24
    pnpm
    posting
    ripgrep
    tmux
    unzip
    wget
    xclip
    yazi
    pkgs.zsh-powerlevel10k
  ];

  # Yazi file manager configuration (copied from @home/programs/yazi.nix)
  programs.yazi = {
    enable = true; # Enable Yazi program.
    enableZshIntegration = true; # Enable integration with ZSH shell.
    # Here pass all the configuration settings for Yazi. https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/yazi-default.toml
    settings = {
      # Configurations for the plugins here.
      mgr = {
        show_hidden = true;
      };
    };
  };

  # Configure Neovim as the main text editor for the user.
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Set environment variables for the user session.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Configure Git for the user.
  programs.git = {
    enable = true;
    settings = {
      user.name = "bryaneduarr";
      user.email = "bryaneduarr@gmail.com";
      init.defaultBranch = "main"; # Use 'main' as the default branch for new repositories.
      core.editor = "nvim"; # Use Neovim for commit messages and other editing tasks.
    };
  };

  # Configure ZSH as the user's shell with zplug and Powerlevel10k prompt.
  programs.zsh = {
    enable = true;

    history = {
      size = 10000; # Limit of history.
      save = 10000; # Limit of history.
      path = "${config.home.homeDirectory}/.zsh_history"; # The directory will be created automatically by home-manager.
      append = true; # setopt APPEND_HISTORY.
      ignoreDups = true; # setopt HIST_IGNORE_DUPS.
      ignoreAllDups = true; # setopt HIST_IGNORE_ALL_DUPS.
      saveNoDups = true; # setopt HIST_SAVE_NO_DUPS.
      findNoDups = true; # setopt HIST_FIND_NO_DUPS.
      ignoreSpace = true; # setopt HIST_IGNORE_SPACE.
      expireDuplicatesFirst = true; # setopt HIST_EXPIRE_DUPS_FIRST.
      share = true; # setopt SHARE_HISTORY.
      extended = false; # unsetopt EXTENDED_HISTORY.
    };

    # Custom aliases for ZSH.
    shellAliases = {
      l = "exa";
      ll = "exa -l";
      la = "exa -la";
      ls = "exa";
      cat = "bat";
      grep = "rg";
      find = "fd";
      top = "btop";
    };

    # Add all of the ZSH plugins here.
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "jeffreytse/zsh-vi-mode"; }
        { name = "romkatv/powerlevel10k"; tags = [ "as:theme" "depth:1" ]; }
        { name = "zsh-users/zsh-completions"; }
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "Aloxaf/fzf-tab"; }
      ];
    };

    # Configuration file for ZSH.
    initContent = ''
       # Aliases for modern CLI tools.
       alias ls="eza"
       alias lla="eza -la"
       alias cat="bat"

       # Function to update and rebuild the system using flakes.
       update() {
        sudo nixos-rebuild switch --flake ~/nix-config/#nixos "$@"
      }

      # Set the default editor to Neovim.
      export EDITOR=nvim

      # Add bun global bin directory to PATH.
      export PATH="$HOME/.bun/bin:$PATH"

      # Preview directories for `cd` with eza tree and colors.
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --color=always --level=2 $realpath'

      # Preview files for a list of commands using bat.
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

  # Merge all home.file entries into a single attribute set.
  home.file = {
    ".tmux/plugins/tpm" = {
      source = builtins.fetchGit {
        url = "https://github.com/tmux-plugins/tpm.git";
      };
      recursive = true;
    };
    ".p10k.zsh".source = ./../home-manager/.p10k.zsh;
  };

  # Configure Tmux as the user's terminal multiplexer.
  programs.tmux = {
    enable = true;

    # Custom Tmux configuration, similar to a .tmux.conf file.
    extraConfig = ''
      unbind r # Unbind the default 'r' key to avoid conflicts.
      bind r source-file ~/.config/tmux/tmux.conf # Reload Tmux config with 'r'.

      # Enable true color support for better visuals in terminal applications.
      set-option -sa terminal-overrides ",xterm*:Tc"
      set -g default-terminal "tmux-256color"

      set -g mouse on # Enable mouse support for pane and window navigation.
      set -g escape-time 0 # Reduce escape time for faster key response.

      # Use Vim-style keys for pane navigation (h/j/k/l).
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # set vi-mode
      set-window-option -g mode-keys vi

      # Terminal ouput selection
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      set -g status-style bg=default # Make the status bar background transparent.

      # Optionally show time and date on the status bar right side.
      # set-option -g status-right "%H:%M %d-%b-%y"

      # Enable TPM plugins for session management and custom status bar.
      set -g @plugin 'tmux-plugins/tmux-resurrect' # Save/restore tmux sessions.
      set -g @plugin 'tmux-plugins/tmux-continuum' # Auto-save and restore tmux environment.
      set -g @plugin 'vaaleyard/tmux-dotbar' # Custom dotbar status theme.

      # Dotbar theme and appearance settings.
      set -g @tmux-dotbar-bg "default" # Set dotbar background color.
      set -g @tmux-dotbar-fg-prefix "#cba6f7" # Set dotbar prefix foreground color.
      set -g @tmux-dotbar-right true # Enable right side of dotbar.
      set -g @tmux-dotbar-status-right "%H:%M %d-%b-%y" # Show time and date on dotbar.

      set -g @continuum-restore 'on' # Enable automatic restoration of tmux sessions.

      # Initialize TPM (Tmux Plugin Manager) at the end of the config.
      run '~/.tmux/plugins/tpm/tpm'
    '';
  };
}
