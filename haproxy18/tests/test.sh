#!/bin/sh
TESTDIR="$(dirname "${0}")"
PLANDIR="$(dirname "${TESTDIR}")"
SKIPBUILD=${SKIPBUILD:-0}

doj pkg install karate/busybox-static
doj pkg binlink karate/busybox-static netstat

doj pkg install --binlink karate/bats
source "${PLANDIR}/plan.sh"

if [ "${SKIPBUILD}" -eq 0 ]; then
  set -e
  pushd "$(dirname "${PLANDIR}")" > /dev/null
  build "${pkg_name}"
  source results/last_build.env
  doj svc load -f karate/nginx
  echo '[http.listen]
port = 81' | doj config apply nginx.default "$(date +%s)"
  # Unload the service if its already loaded.
  doj svc unload "${DOJ_ORIGIN}/${pkg_name}"
  doj pkg install --binlink --force "results/${pkg_artifact}"
  doj svc load "${pkg_ident}" --bind=backend:nginx.default
  popd > /dev/null
  set +e
fi

echo "Waiting 5 seconds for haproxy to start..."
sleep 5

bats "${TESTDIR}/test.bats"
