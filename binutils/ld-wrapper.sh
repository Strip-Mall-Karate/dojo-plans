#!@shell@
#
# Takes the place of @program@ so that two options are added: the dynamic
# linker of the glibc this package was built with, and an -rpath for each
# entry of $LD_RUN_PATH. POSIX sh, so it runs before any karate shell exists.
set -e

set -- -dynamic-linker "@dynamic_linker@" "$@"
saved_ifs=$IFS
IFS=:
for path in ${LD_RUN_PATH:-}; do
  if [ -n "$path" ]; then
    set -- "$@" -rpath "$path"
  fi
done
IFS=$saved_ifs

exec "@program@" "$@"
