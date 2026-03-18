{ lib, ... }:
{
  home.activation.copyNvim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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

    # Download Spanish spell files if not present (try multiple mirrors)
    echo "Downloading Spanish spell files for Neovim..."
    SPELL_DIR="$HOME/.config/nvim/spell"
    mkdir -p "$SPELL_DIR"

    if [ ! -f "$SPELL_DIR/es.utf-8.spl" ]; then
      for url in \
        "https://ftp.nluug.nl/pub/vim/runtime/spell/es.utf-8.spl" \
        "https://raw.githubusercontent.com/vim/vim/master/runtime/spell/es.utf-8.spl"; do
        timeout 60 curl -L --connect-timeout 10 --max-time 30 "$url" -o "$SPELL_DIR/es.utf-8.spl" 2>/dev/null && break
      done
      [ -f "$SPELL_DIR/es.utf-8.spl" ] || echo "Warning: Could not download es.utf-8.spl spell file"
    fi

    if [ ! -f "$SPELL_DIR/es.utf-8.sug" ]; then
      for url in \
        "https://ftp.nluug.nl/pub/vim/runtime/spell/es.utf-8.sug" \
        "https://raw.githubusercontent.com/vim/vim/master/runtime/spell/es.utf-8.sug"; do
        timeout 60 curl -L --connect-timeout 10 --max-time 30 "$url" -o "$SPELL_DIR/es.utf-8.sug" 2>/dev/null && break
      done
      [ -f "$SPELL_DIR/es.utf-8.sug" ] || echo "Warning: Could not download es.utf-8.sug spell file"
    fi
  '';
}
