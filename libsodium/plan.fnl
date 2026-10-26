;; libsodium, ported from its plan.sh.
{:name "libsodium"
 :origin "karate"
 :version "1.0.16"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["ISC"]
 :description "Sodium is a new, easy-to-use software library for encryption, decryption, signatures, password hashing and more. It is a portable, cross-compilable, installable, packageable fork of NaCl, with a compatible API, and an extended API to improve usability even further."
 :upstream_url "https://github.com/jedisct1/libsodium"
 :source {:url "https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz" :sha256 "eeadc7e1e1bcef09680fb4837d448fbdf57224978f865ac1c16745868fbd0533" :dirname "libsodium-1.0.16"}
 :deps ["karate/glibc"]
 :build_deps ["karate/autoconf" "karate/automake" "karate/diffutils" "karate/patch" "karate/make" "karate/gcc" "karate/sed"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :check (fn [b]
          (b:run ["make" "check"]))}
