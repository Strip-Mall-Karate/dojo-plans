#!/bin/sh

TESTDIR="$(dirname "${0}")"
PLANDIR="$(dirname "${TESTDIR}")"
SKIPBUILD=${SKIPBUILD:-0}

doj pkg install --binlink karate/bats
doj pkg install --binlink --force "karate/corretto8"

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

JAVA_HOME="$(doj pkg path karate/corretto8)"
export JAVA_HOME

bats "${TESTDIR}/test.bats"

rm -rf "${PLANDIR}/../.gradle"
