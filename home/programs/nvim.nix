{ lib, pkgs, ... }:

{
  home.activation.copyNvim = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Copying nvim configuration..."
    rm -rf "$HOME/.config/nvim"

    # Ensure ~/.config exists before copying
    if [ ! -d "$HOME/.config" ]; then
      mkdir -p "$HOME/.config"
    fi

    # Only copy if the nvim directory exists and has content
    if [ -d ${toString ../../nvim} ] && [ "$(ls -A ${toString ../../nvim})" ]; then
      cp -r ${toString ../../nvim} "$HOME/.config/nvim"
      chmod -R u+w "$HOME/.config/nvim"
    else
      # Create an empty nvim config directory if source is empty
      mkdir -p "$HOME/.config/nvim"
      echo "-- Empty Neovim configuration" > "$HOME/.config/nvim/init.lua"
    fi
  '';

  home.activation.installNvimSpellEs =
    lib.hm.dag.entryAfter ["linkGeneration"] ''
      SPELL_DIR="$HOME/.config/nvim/spell"
      mkdir -p "$SPELL_DIR"

      if [ ! -f "$SPELL_DIR/es.utf-8.spl" ]; then
        ${pkgs.curl}/bin/curl -L \
          https://ftp.nluug.nl/pub/vim/runtime/spell/es.utf-8.spl \
          -o "$SPELL_DIR/es.utf-8.spl"
      fi

      if [ ! -f "$SPELL_DIR/es.utf-8.sug" ]; then
        ${pkgs.curl}/bin/curl -L \
          https://ftp.nluug.nl/pub/vim/runtime/spell/es.utf-8.sug \
          -o "$SPELL_DIR/es.utf-8.sug"
      fi
    '';
}
