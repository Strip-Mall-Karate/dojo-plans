#!@shell@
#
# Takes the place of @program@ so that it finds this package's glibc and
# binutils: their headers, start files and assembler and linker, and, when
# linking, glibc's dynamic linker. A link with musl-gcc's specs is left to
# them. When linking, LD_RUN_PATH's entries become -rpath options, so the
# RUNPATH is set whichever linker the driver runs: rustc's bundled lld does
# not read LD_RUN_PATH. POSIX sh, so it runs before any karate shell exists.
set -e

link=yes
inputs=no
musl=no
for arg in "$@"; do
  case "$arg" in
    -c | -S | -E | -M | -MM | -x) link=no ;;
    *musl-gcc.specs) musl=yes ;;
    -*) ;;
    *) inputs=yes ;;
  esac
done
if [ "$inputs" = no ]; then
  link=no
fi

if [ "$*" = -v ] || [ "$musl" = yes ]; then
  exec "@program@" "$@"
fi

# Before the arguments, the dynamic linker; after them, where glibc and
# binutils are, and C++'s headers for the C++ compiler.
set -- "$@" -B@glibc@/lib/ -idirafter @glibc@/include
for fixed in @gcc@/lib/gcc/*/*/include-fixed; do
  set -- "$@" -idirafter "$fixed"
done
set -- "$@" -B@binutils@/bin/
case "$(basename "@program@")" in
  *++)
    case " $* " in
      *" -nostdlib "*) ;;
      *)
        machine=$(@gcc@/bin/gcc -dumpmachine)
        for dir in @gcc@/include/c++/*; do
          set -- "$@" -isystem "$dir" -isystem "$dir/$machine"
        done
        ;;
    esac
    ;;
esac
if [ "$link" = yes ]; then
  saved_ifs=$IFS
  IFS=:
  for path in ${LD_RUN_PATH:-}; do
    if [ -n "$path" ]; then
      set -- "$@" -Wl,-rpath -Wl,"$path"
    fi
  done
  IFS=$saved_ifs
  # Given once here: binutils' ld would otherwise add the same entries again.
  unset LD_RUN_PATH
  set -- -Wl,-dynamic-linker -Wl,@dynamic_linker@ "$@"
fi

exec "@program@" "$@"
