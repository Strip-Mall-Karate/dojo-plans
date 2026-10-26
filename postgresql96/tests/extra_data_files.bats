source "${BATS_TEST_DIRNAME}/../plan.sh"

NONDOJ_FILE="/doj/svc/${pkg_name}/data/lost+found"

function setup() {
  touch "${NONDOJ_FILE}"
  chown root:root "${NONDOJ_FILE}"
  chmod 600 "${NONDOJ_FILE}"
}

function teardown() {
    rm -f ${NONDOJ_FILE}
}

@test "Non-Dojo owned files in /data are allowed" {
  ORIGIN=$(doj svc status |grep ${pkg_name}| cut -f1 -d'/')
  doj svc stop "${ORIGIN}/${pkg_name}"

  doj svc start "${ORIGIN}/${pkg_name}"

  # Wait for service to start
  sleep 1

  # We still have a non-Dojo owned file in data/
  [ -f "${NONDOJ_FILE}" ]
  [ "root" == $(stat -c %U "${NONDOJ_FILE}") ]
  [ "root" == $(stat -c %G "${NONDOJ_FILE}") ]
  [ "-rw-------" == $(stat -c %A "${NONDOJ_FILE}") ]

  [ "$(doj svc status | grep "${pkg_name}.default" | awk '{print $4}' | grep up)" ]
}
