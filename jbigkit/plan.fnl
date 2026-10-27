;; jbigkit, ported from its plan.sh.
{:name :jbigkit
 :origin :karate
 :version :2.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-2.0]
 :description "An implementation of the JBIG1 data compression standard"
 :upstream_url "http://www.cl.cam.ac.uk/~mgk25/jbigkit/"
 :source {:url "http://www.cl.cam.ac.uk/~mgk25/jbigkit/download/jbigkit-2.1.tar.gz"
          :sha256 :de7106b6bfaf495d6865c7dd7ac6ca1381bd12e0d81405ea81e7f2167263d932}
 :deps [:karate/glibc]
 :build_deps [:karate/gcc
              :karate/make
              :karate/patch
              :karate/coreutils
              :karate/diffutils]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :prepare (fn [b]
            (b:run [:patch
                    :-p1
                    :-i
                    (.. b.plan_dir :/libjbig-shared-library.patch)]))
 :build (fn [b]
          (b:run [:make]))
 :check (fn [b]
          (b:run [:make :test]))
 :install (fn [b]
            (var v--bin-dir "")
            (var v--binaries "")
            (var v--include-dir "")
            (var v--lib-dir "")
            (set v--lib-dir (.. b.prefix :/lib))
            (set v--include-dir (.. b.prefix :/include))
            (set v--bin-dir (.. b.prefix :/bin))
            (set v--binaries "jbgtopbm jbgtopbm85 pbmtojbg pbmtojbg85")
            (b:mkdir v--lib-dir)
            (b:mkdir v--include-dir)
            (b:mkdir v--bin-dir)
            (b:copy (b:join b.src (.. :libjbig/libjbig.so. b.version))
                    v--lib-dir)
            (b:chmod v--lib-dir :0755)
            (b:copy (b:join b.src (.. :libjbig/libjbig85.so. b.version))
                    v--lib-dir)
            (b:chmod v--lib-dir :0755)
            (let [link (if (b:exists (b:join (.. v--lib-dir :/libjbig.so) "."))
                           (b:join (.. v--lib-dir :/libjbig.so)
                                   (: (.. :libjbig.so. b.version) :match
                                      "[^/]+$"))
                           (.. v--lib-dir :/libjbig.so))]
              (b:remove link)
              (b:symlink (.. :libjbig.so. b.version) link))
            (let [link (if (b:exists (b:join (.. v--lib-dir :/libjbig85.so) "."))
                           (b:join (.. v--lib-dir :/libjbig85.so)
                                   (: (.. :libjbig85.so. b.version) :match
                                      "[^/]+$"))
                           (.. v--lib-dir :/libjbig85.so))]
              (b:remove link)
              (b:symlink (.. :libjbig85.so. b.version) link))
            (b:copy (b:join b.src :libjbig/jbig.h) v--include-dir)
            (b:chmod v--include-dir :0644)
            (b:copy (b:join b.src :libjbig/jbig85.h) v--include-dir)
            (b:chmod v--include-dir :0644)
            (b:copy (b:join b.src :libjbig/jbig_ar.h) v--include-dir)
            (b:chmod v--include-dir :0644)
            (each [_ v-b (ipairs [v--binaries])]
              (b:copy (b:join b.src (.. :pbmtools/ v-b)) v--bin-dir)
              (b:chmod v--bin-dir :0755)))}
