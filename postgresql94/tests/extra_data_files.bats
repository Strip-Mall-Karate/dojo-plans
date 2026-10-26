NONDOJ_FILE="/doj/svc/postgresql94/data/lost+found"

function setup() {
  touch "${NONDOJ_FILE}"
  chown root:root "${NONDOJ_FILE}"
  chmod 600 "${NONDOJ_FILE}"
}

function teardown() {
    rm -f ${NONDOJ_FILE}
}

@test "Non-Dojo owned files in /data are allowed" {
  ORIGIN=$(doj svc status |grep postgresql94| cut -f1 -d'/')
  doj svc stop "${ORIGIN}/postgresql94"

  doj svc start "${ORIGIN}/postgresql94"

  # Wait for service to start
  sleep 1

  # We still have a non-Dojo owned file in data/
  [ -f "${NONDOJ_FILE}" ]
  [ "root" == $(stat -c %U "${NONDOJ_FILE}") ]
  [ "root" == $(stat -c %G "${NONDOJ_FILE}") ]
  [ "-rw-------" == $(stat -c %A "${NONDOJ_FILE}") ]

  [ "$(doj svc status | grep "postgresql94.default" | awk '{print $4}' | grep up)" ]
}
