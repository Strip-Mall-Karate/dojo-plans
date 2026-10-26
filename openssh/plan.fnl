;; openssh, ported from its plan.sh.
{:name "openssh"
 :origin "karate"
 :version "7.5p1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["bsd"]
 :description "Provides OpenSSH client and server."
 :upstream_url "https://www.openssh.com/"
 :source {:url "https://cloudflare.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.5p1.tar.gz" :sha256 "9846e3c5fab9f0547400b4d2c017992f914222b3fd1f8eee6c7dc6bc5e59f9f0"}
 :deps ["karate/glibc" "karate/openssl" "karate/zlib"]
 :build_deps ["karate/coreutils" "karate/gcc" "karate/make"]
 :bin_dirs ["bin" "sbin" "libexec"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :svc {:user "root" :group "root"}
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--sysconfdir=/doj/svc/openssh/config" "--localstatedir=/doj/svc/openssh/var" "--datadir=/doj/svc/openssh/data" "--with-privsep-user=doj" (.. "--with-privsep-path=" b.prefix "/var/empty")])
          (b:run ["make"]))
 :install (fn [b]
          (b:run ["make" "install-nosysconf"])
          (b:mkdir (.. b.prefix "/var/empty"))
          (b:chmod (.. b.prefix "/var/empty") "700"))}
