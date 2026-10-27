;; meson, ported from its plan.sh.
;; meson 1.12.1, the latest release on 2026-10-27, installed as the single-file zipapp its
;; packaging makes: Python 3.15 has no setuptools for setup.py.
{:name :meson
 :origin :karate
 :version :1.12.1
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "The Meson Build System"
 :upstream_url "https://mesonbuild.com/"
 :source {:url "https://github.com/mesonbuild/meson/releases/download/1.12.1/meson-1.12.1.tar.gz"
          :sha256 :ab0a6ca09f8ef70c564c8241fb5a23957886a0b53fb58412b5e07eaf07dba743}
 :deps [:karate/python :karate/ninja]
 :bin_dirs [:bin]
 :build (fn [b]
          nil)
 :install (fn [b]
            (b:mkdir (b:join b.prefix :bin))
            (b:run [:python3
                    :packaging/create_zipapp.py
                    :--outfile
                    (b:join b.prefix :bin/meson)
                    :--interpreter
                    (.. (b:path_for :python) :/bin/python3)
                    "."]))}
