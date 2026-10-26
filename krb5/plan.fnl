;; krb5, ported from its plan.sh.
{:name "krb5"
 :origin "karate"
 :version "1.14.3"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.1"]
 :description "Kerberos is a network authentication protocol. It is designed\nto provide strong authentication for client/server applications by using\nsecret-key cryptography."
 :upstream_url "http://web.mit.edu/kerberos/www/"
 :source {:url "http://web.mit.edu/kerberos/dist/krb5/1.14/krb5-1.14.3.tar.gz" :sha256 "cd4620d520cf0df0dd8791309912df2bb20fcba76790b9fba4e25c1da08ff2c9"}
 :deps ["karate/glibc"]
 :build_deps ["karate/bison" "karate/busybox" "karate/gcc" "karate/m4" "karate/make" "karate/perl"]
 :bin_dirs ["bin" "sbin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix)] {:cwd "src"})
          (b:run ["make"] {:cwd "src"}))
 :install (fn [b]
          (b:run ["make" "install"] {:cwd "src"}))}
