#!/bin/sh

TESTDIR="$(dirname "${0}")"
PLANDIR="$(dirname "${TESTDIR}")"
SKIPBUILD=${SKIPBUILD:-0}

doj pkg install --binlink karate/bats

doj pkg install karate/busybox-static
doj pkg binlink karate/busybox-static ps
doj pkg binlink karate/busybox-static netstat
doj pkg binlink karate/busybox-static wc
doj pkg binlink karate/busybox-static uniq

source "${PLANDIR}/plan.sh"
# Unload the service if its already loaded.
doj svc unload "${DOJ_ORIGIN}/${pkg_name}"

if [ "${SKIPBUILD}" -eq 0 ]; then
  set -e
  pushd "${PLANDIR}" > /dev/null
  build
  source results/last_build.env
  doj pkg install --binlink --force "results/${pkg_artifact}"
  doj svc load "${pkg_ident}"
  popd > /dev/null
  set +e

  # Give some time for the service to start up
  sleep 5
fi

bats "${TESTDIR}/test.bats"
