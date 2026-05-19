#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
release_dir="$repo_root/pkgs/engram"
release_file="$release_dir/release.json"
pkg_name="gentle-engram"

for cmd in curl jq nix npm; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$cmd" >&2
    exit 1
  fi
done

npm_json="$(curl -fsSL "https://registry.npmjs.org/$pkg_name/latest")"
version="$(printf '%s' "$npm_json" | jq -r '.version')"

if [ -z "$version" ] || [ "$version" = "null" ]; then
  printf 'Failed to resolve the latest %s version.\n' "$pkg_name" >&2
  exit 1
fi

tarball_url="https://registry.npmjs.org/$pkg_name/-/$pkg_name-${version}.tgz"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

tarball="$tmp_dir/pkg.tgz"
curl -fsSLo "$tarball" "$tarball_url"

src_hash="$(nix hash file --base16 --type sha256 "$tarball" | xargs nix hash convert --hash-algo sha256 --to sri)"

tar xzf "$tarball" -C "$tmp_dir"
cp "$tmp_dir/package/package.json" "$tmp_dir/"

cd "$tmp_dir/package"
npm install --package-lock-only 2>&1 | tail -2
cd "$tmp_dir"
cp package/package-lock.json .

cat > "$tmp_dir/compute-hash.nix" << 'EOF'
{ pkgs ? import <nixpkgs> {} }:
pkgs.fetchNpmDeps {
  src = ./.;
  hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
}
EOF

npm_deps_hash="$(
  nix build -f "$tmp_dir/compute-hash.nix" 2>&1 | grep -oP 'got:\s*\K\S+' || true
)"

if [ -z "$npm_deps_hash" ]; then
  printf 'Failed to compute npmDepsHash.\n' >&2
  exit 1
fi

tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"; rm -rf "$tmp_dir"' EXIT

jq -n \
  --arg version "$version" \
  --arg srcHash "$src_hash" \
  --arg npmDepsHash "$npm_deps_hash" \
  '{ version: $version, srcHash: $srcHash, npmDepsHash: $npmDepsHash }' \
  > "$tmp_file"

mv "$tmp_file" "$release_file"
cp "$tmp_dir/package-lock.json" "$release_dir/"
printf 'Updated engram release metadata to %s\n' "$version"
