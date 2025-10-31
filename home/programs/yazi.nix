{ config, pkgs, yazi-plugins, yazi-flavors, ... }:

{
  programs.yazi = {
    enable = true; # Enable Yazi program.

    enableZshIntegration = true; # Enable integration with ZSH shell.

    # Here pass all the configuration settings for Yazi. https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/yazi-default.toml
    settings = {
      # Configurations for the plugins here.
      plugin = {
        prepend_fetchers = [
          { id = "git"; name = "*"; run = "git"; } # Register git fetchers ahead of defaults. This is for the plugin git to work correctly.
          { id = "git"; name = "*/"; run = "git"; } # Default git fetcher.
        ];
      };
    };

    # In here add all the keymaps from Yazi. https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/keymap-default.toml
    keymap = { };

    # Theme configuration for Yazi.
    theme = {
      flavor = {
        dark = "catppuccin-mocha"; # Use for dark-mode the catppuccin-mocha flavor from yazi. https://github.com/yazi-rs/flavors/tree/main/catppuccin-mocha.yazi
      };
    };

    # Plugin configuration for Yazi. Here add all of the plugins with names and paths.
    # The name '${yazi-plugins}' for example, is coming from the flake.nix file where these custom flakes are defined.
    plugins = {
      full-border = "${yazi-plugins}/full-border.yazi"; # https://github.com/yazi-rs/plugins/tree/main/full-border.yazi
      git = "${yazi-plugins}/git.yazi"; # https://github.com/yazi-rs/plugins/tree/main/git.yazi
    };

    # Lua initialization script for plugins or other configuration.
    initLua = ''
      -- Load all the plugins with lua here. Important to load here.
      require("full-border"):setup()
      require("git"):setup()
    '';
  };

  # It ensures that the file "catppuccin-mocha.yazi" from the "yazi-flavors" package
  # is linked or copied to the ".config/yazi/flavors/" directory in the user's home.
  home.file = {
    ".config/yazi/flavors/catppuccin-mocha.yazi" = {
      source = "${yazi-flavors}/catppuccin-mocha.yazi";
      recursive = true;
    };
  };

  # These packages enhance file management and media handling capabilities in the user's environment when using yazi.
  home.packages = with pkgs; [
    file # for determining file types.
    bat # a cat clone with syntax highlighting.
    eza # a modern replacement for 'ls'.
    fzf # a command-line fuzzy finder.
    ffmpegthumbnailer # for generating video thumbnails.
    imagemagick # a suite for image manipulation.
    poppler-utils # PDF utilities (e.g., pdftotext).
    mpv # a media player.
    p7zip # 7z archive tool.
    unrar # tool for extracting RAR archives.
    unzip # tool for extracting ZIP archives.
  ];
}
