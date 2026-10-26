;; systemd, ported from its plan.sh.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (: f :match "[^/]+$")]
      (when (and (or (: name :match "^configure") (: name :match "^Makefile") (: name :match "^ltmain")
                     (: name :match "%.in$") (: name :match "%.am$") (: name :match "%.ac$")
                     (: name :match "%.m4$") (: name :match "%.mk$") (: name :match "%.sh$")
                     (: name :match "%.pl$") (: name :match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1 (: path :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0"))
              (fixed n) (: text :gsub escaped (pick-values 1 (: replacement :gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))
{:name "systemd"
 :origin "karate"
 :version "239"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["LGPL-2.1"]
 :description "systemd is an init system used in Linux distributions to bootstrap the user space. Subsequently to booting, it is used to manage system processes."
 :upstream_url "https://github.com/systemd/systemd"
 :source {:url "https://github.com/systemd/systemd/archive/v239.tar.gz" :sha256 "8a11b1b07d620f4c06a16e95bba4dd2a97e90efdf2a5ba47ed0a935085787a14"}
 :deps ["karate/glibc" "karate/libcap" "karate/lz4" "karate/util-linux" "karate/xz"]
 :build_deps ["karate/coreutils" "karate/dbus" "karate/gcc" "karate/gettext" "karate/gperf" "karate/m4" "karate/meson" "karate/ninja" "karate/pkg-config"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib" "var/lib" "usr/lib"]
 :include_dirs ["include"]
 :svc {:user "root" :group "root"}
 :prepare (fn [b]
          (use-dependency-path b "/usr/bin/env" (b:path_for "karate/coreutils" "bin/env"))
          (b:env "LANG" "en_US.utf8")
          (b:env "LC_ALL" "en_US.utf8")
          (b:env "LD_RUN_PATH" (.. (or (b:getenv "LD_RUN_PATH") "") ":" b.prefix "/lib:" b.prefix "/lib/systemd")))
 :build (fn [b]
          (var v-meson-opts "")
          (set v-meson-opts [(.. "--prefix=" b.prefix) "-Dman=false" "-Dhtml=false" "-Dpython=false" (.. "-Drootprefix=" b.prefix) (.. "-Drootlibdir=" b.prefix "/lib") (.. "-Ddbuspolicydir=" b.prefix "/etc/dbus-1/system.d") (.. "-Ddbussessionservicedir=" b.prefix "/etc/dbus-1/services") (.. "-Ddbussystemservicedir=" b.prefix "/etc/dbus-1/system-services") "-Dtests=false"])
          (b:run (let [args []] (table.insert args "meson") (table.insert args "build") (each [_ x (ipairs v-meson-opts)] (table.insert args x)) args))
          (b:run ["ninja" "-C" "build"]))
 :install (fn [b]
          (b:run ["ninja" "-C" "build" "install"]))}
