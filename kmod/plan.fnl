;; kmod, ported from its plan.sh.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (: f :match "[^/]+$")]
      (when (and (or (: name :match :^configure) (: name :match :^Makefile)
                     (: name :match :^ltmain) (: name :match "%.in$")
                     (: name :match "%.am$") (: name :match "%.ac$")
                     (: name :match "%.m4$") (: name :match "%.mk$")
                     (: name :match "%.sh$") (: name :match "%.pl$")
                     (: name :match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1
                                   (: path :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]"
                                      "%%%0"))
              (fixed n) (: text :gsub escaped
                           (pick-values 1 (: replacement :gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))

{:name :kmod
 :origin :karate
 :version :24
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:LGPL-2.1]
 :description "Linux kernel module management tools and library"
 :upstream_url "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git"
 :source {:url "https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-24.tar.xz"
          :sha256 :610b8d1df172acc39a4fdf1eaa47a57b04873c82f32152e7a62e29b6ff9cb397}
 :deps [:karate/glibc :karate/xz :karate/zlib]
 :build_deps [:karate/make
              :karate/gcc
              :karate/pkg-config
              :karate/file
              :karate/sed
              :karate/diffutils]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :pconfig_dirs [:lib/pkgconfig]
 :download (fn [b]
             ;; From do_before.
             (use-dependency-path b :/usr/bin/file
                                  (b:path_for :karate/file :bin/file))
             (b.default.download b))
 :build (fn [b]
          (b:run [:./configure
                  (.. :--prefix= b.prefix)
                  :--with-xz
                  :--with-zlib])
          (b:run [:make]))
 :install (fn [b]
            (b.default.install b)
            (each [_ v-bin (ipairs [:depmod
                                    :insmod
                                    :lsmod
                                    :modinfo
                                    :modprobe
                                    :rmmod])]
              (let [link (if (b:exists (b:join (if (= (: v-bin :sub 1 1) "/")
                                                   v-bin
                                                   (b:join (.. b.prefix :/bin)
                                                           v-bin))
                                               "."))
                             (b:join (if (= (: v-bin :sub 1 1) "/") v-bin
                                         (b:join (.. b.prefix :/bin) v-bin))
                                     :kmod)
                             (if (= (: v-bin :sub 1 1) "/") v-bin
                                 (b:join (.. b.prefix :/bin) v-bin)))]
                (b:symlink :kmod link))))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
