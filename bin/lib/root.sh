# shellcheck shell=bash
# smk { overwrite: false }
#########################################################################
#
#                 -- Generated with smk --
#      (do not edit unless you know what you're doing)
#
#########################################################################
#
# Sourced by bin/ scripts. Sets WORKSPACE, the repo root, found by its marker file (smkproj.toml)
# rather than by counting parent directories.

find_workspace() {
  local dir="$1"
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/smkproj.toml" ]]; then
      printf '%s\n' "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  echo >&2 "error: no smkproj.toml above $1; this script belongs to an smk project."
  return 1
}

WORKSPACE="$(find_workspace "$SCRIPT_DIR")"
# shellcheck disable=SC2034 # read by the scripts that source this file
readonly WORKSPACE
