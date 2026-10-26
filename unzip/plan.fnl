;; unzip, ported from its plan.sh.
{:name "unzip"
 :origin "karate"
 :version "6.0"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Zlib"]
 :description "UnZip is an extraction utility for archives compressed in .zip format (also called 'zipfiles')."
 :upstream_url "https://sourceforge.net/projects/infozip/"
 :source {:url "https://downloads.sourceforge.net/infozip/unzip60.tar.gz" :sha256 "036d96991646d0449ed0aa952e4fbe21b476ce994abc276e49d30e686708bd37" :dirname "unzip60"}
 :deps ["karate/bzip2" "karate/glibc"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :build (fn [b]
          (var v-prefix "")
          (var v-defines "-DACORN_FTYPE_NFS -DWILD_STOP_AT_DIR -DLARGE_FILE_SUPPORT     -DUNICODE_SUPPORT -DUNICODE_WCHAR -DUTF8_MAYBE_NATIVE -DNO_LCHMOD     -DDATE_FORMAT=DF_YMD -DUSE_BZIP2 -DNOMEMCPY -DNO_WORKING_ISPRINT")
          (b:run ["make" "-f" "unix/Makefile" (.. "prefix=" b.prefix) "D_USE_BZ2=-DUSE_BZIP2" "L_BZ2=-lbz2" (.. "LF2=" (or (b:getenv "LDFLAGS") "")) (.. "CF=" (or (b:getenv "CFLAGS") "") " " (or (b:getenv "CPPFLAGS") "") " -I. " v-defines) "unzips"]))
 :install (fn [b]
          (b:run ["make" "-f" "unix/Makefile" (.. "prefix=" b.prefix) "install"]))}
