#!/bin/sh

TESTDIR="$(dirname "${0}")"
PLANDIR="$(dirname "${TESTDIR}")"
SKIPBUILD=${SKIPBUILD:-0}

doj pkg install --binlink karate/bats

source "${PLANDIR}/plan.sh"

if [ "${SKIPBUILD}" -eq 0 ]; then
  set -e
  pushd "${PLANDIR}" > /dev/null
  build
  source results/last_build.env
  doj pkg install --binlink --force "results/${pkg_artifact}"
  ln -sf "$(doj pkg path karate/iana-etc)/etc/protocols" /etc/protocols
  popd > /dev/null
  set +e
fi

if [[ ! -f /etc/protocols ]]; then
	doj pkg install karate/iana-etc
	ln -s "$(doj pkg path karate/iana-etc)/etc/protocols" /etc/protocols
fi

bats "${TESTDIR}/test.bats"
