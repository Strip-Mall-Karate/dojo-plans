#!/bin/sh

TESTDIR="$(dirname "${0}")"
PLANDIR="$(dirname "${TESTDIR}")"
SKIPBUILD=${SKIPBUILD:-0}

source "${PLANDIR}/plan.sh"

if [ "${SKIPBUILD}" -eq 0 ]; then
  # Unload the service if its already loaded.
  doj svc unload "${DOJ_ORIGIN}/${pkg_name}"

  set -e
  pushd "${PLANDIR}" > /dev/null
  build
  source results/last_build.env
  doj pkg install --binlink --force "results/${pkg_artifact}"
  doj svc load "${pkg_ident}"
  popd > /dev/null
  set +e

  # Give some time for the service to start up
  local _seconds=20
  echo "Waiting for ${pkg_name} to start up (${_seconds} seconds)"
  sleep ${_seconds}
fi

doj pkg install --binlink karate/coreutils-static
doj pkg install --binlink karate/glibc
doj pkg install --binlink karate/corretto8
doj pkg install --binlink karate/wget
doj pkg install --binlink karate/curl
doj pkg install --binlink karate/busybox-static

doj pkg install --binlink karate/bats

bats "${TESTDIR}/test.bats"
