;; nspr, ported from its plan.sh.
{:name "nspr"
 :origin "karate"
 :version "4.12"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["MPL-2.0"]
 :description "Netscape Portable Runtime"
 :upstream_url "https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSPR"
 :source {:url "https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.12/src/nspr-4.12.tar.gz" :sha256 "e0b10a1e569153668ff8bdea6c7e491b389fab69c2f18285a1ebf7c2ea4269de"}
 :deps ["karate/glibc"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include/nspr"]
 :build (fn [b]
          (b:run ["./nspr/configure" (.. "--prefix=" b.prefix) "--enable-optimize" "--disable-debug" "--enable-64bit"])
          (b:run ["make"]))}
