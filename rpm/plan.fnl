;; rpm, ported from its plan.sh.
{:name :rpm
 :origin :karate
 :version :4.14.2.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0 :LGPL-2.0]
 :description "RPM Package Manager"
 :upstream_url "http://www.rpm.org/"
 :source {:url "http://ftp.rpm.org/releases/rpm-4.14.x/rpm-4.14.2.1.tar.bz2"
          :sha256 :1139c24b7372f89c0a697096bf9809be70ba55e006c23ff47305c1849d98acda}
 :deps [:karate/bzip2
        :karate/db
        :karate/file
        :karate/glibc
        :karate/libarchive
        :karate/nspr
        :karate/nss
        :karate/openssl
        :karate/popt
        :karate/zlib]
 :build_deps [:karate/gcc :karate/make]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--with-external-db
                  :--without-lua])
          (b:run [:make]))}
