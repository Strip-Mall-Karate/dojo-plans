;; json-glib, ported from its plan.sh.
{:name "json-glib"
 :origin "karate"
 :version "1.2.8"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.1"]
 :description "A library for reading and parsing JSON using GLib and GObject data types and API"
 :upstream_url "https://developer.gnome.org/json-glib/"
 :source {:url "https://download.gnome.org/sources/json-glib/1.2/json-glib-1.2.8.tar.xz" :sha256 "fd55a9037d39e7a10f0db64309f5f0265fa32ec962bf85066087b83a2807f40a"}
 :deps ["karate/glib" "karate/glibc" "karate/libffi" "karate/libxslt" "karate/libiconv" "karate/pcre" "karate/util-linux" "karate/zlib"]
 :build_deps ["karate/diffutils" "karate/gcc" "karate/gettext" "karate/make" "karate/perl" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :pconfig_dirs ["lib/pkgconfig"]
 :check (fn [b]
          (b:run ["make" "check"]))}
