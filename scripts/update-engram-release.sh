#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
release_file="$repo_root/pkgs/engram/release.json"
api_url="https://api.github.com/repos/Gentleman-Programming/engram/releases/latest"

for cmd in curl jq nix; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$cmd" >&2
    exit 1
  fi
done

release_json="$(curl -fsSL "$api_url")"
version="$(printf '%s' "$release_json" | jq -r '.tag_name | sub("^v"; "")')"

if [ -z "$version" ] || [ "$version" = "null" ]; then
  printf 'Failed to resolve the latest stable engram release.\n' >&2
  exit 1
fi

checksums_url="https://github.com/Gentleman-Programming/engram/releases/download/v${version}/checksums.txt"
checksums="$(curl -fsSL "$checksums_url")"

asset_hash() {
  local asset_name="$1"
  local hex_hash

  hex_hash="$(printf '%s\n' "$checksums" | awk -v asset="$asset_name" '$2 == asset { print $1 }')"

  if [ -z "$hex_hash" ]; then
    printf 'Missing checksum for asset: %s\n' "$asset_name" >&2
    exit 1
  fi

  nix hash convert --hash-algo sha256 --to sri "$hex_hash"
}

amd64_linux_asset="engram_${version}_linux_amd64.tar.gz"
arm64_linux_asset="engram_${version}_linux_arm64.tar.gz"
amd64_darwin_asset="engram_${version}_darwin_amd64.tar.gz"
arm64_darwin_asset="engram_${version}_darwin_arm64.tar.gz"

tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"' EXIT

jq \
  --arg version "$version" \
  --arg amd64_linux_asset "$amd64_linux_asset" \
  --arg arm64_linux_asset "$arm64_linux_asset" \
  --arg amd64_darwin_asset "$amd64_darwin_asset" \
  --arg arm64_darwin_asset "$arm64_darwin_asset" \
  --arg amd64_linux_hash "$(asset_hash "$amd64_linux_asset")" \
  --arg arm64_linux_hash "$(asset_hash "$arm64_linux_asset")" \
  --arg amd64_darwin_hash "$(asset_hash "$amd64_darwin_asset")" \
  --arg arm64_darwin_hash "$(asset_hash "$arm64_darwin_asset")" \
  '
    .version = $version
    | .platforms = {
        "aarch64-darwin": {
          url: "https://github.com/Gentleman-Programming/engram/releases/download/v\($version)/\($arm64_darwin_asset)",
          hash: $arm64_darwin_hash
        },
        "aarch64-linux": {
          url: "https://github.com/Gentleman-Programming/engram/releases/download/v\($version)/\($arm64_linux_asset)",
          hash: $arm64_linux_hash
        },
        "x86_64-darwin": {
          url: "https://github.com/Gentleman-Programming/engram/releases/download/v\($version)/\($amd64_darwin_asset)",
          hash: $amd64_darwin_hash
        },
        "x86_64-linux": {
          url: "https://github.com/Gentleman-Programming/engram/releases/download/v\($version)/\($amd64_linux_asset)",
          hash: $amd64_linux_hash
        }
      }
  ' \
  "$release_file" > "$tmp_file"

mv "$tmp_file" "$release_file"
printf 'Updated engram release metadata to %s\n' "$version"
