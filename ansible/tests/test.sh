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
  popd > /dev/null
  set +e
fi

PYTHONPATH="$(doj pkg path karate/python2)/lib/python2.7/site-packages:$(doj pkg path "${DOJ_ORIGIN}/${pkg_name}")/lib/python2.7/site-packages"
export PYTHONPATH

bats "${TESTDIR}/test.bats"
