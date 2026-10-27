;; ponysay, ported from its plan.sh.
{:name :ponysay
 :origin :karate
 :version :3.0.2
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:GPL-3.0]
 :description "A cowsay reimplemention for ponies"
 :upstream_url "http://erkin.co/ponysay/"
 :source {:url "https://github.com/erkin/ponysay/archive/3.0.2.tar.gz"
          :sha256 :69e98a7966353de2f232cbdaccd8ef7dbc5d0bcede9bf7280a676793e8625b0d}
 :deps [:karate/coreutils :karate/python]
 :bin_dirs [:bin]
 :build (fn [b]
          nil)
 :install (fn [b]
            (b:fix_interpreter (b:glob (b:join b.src :src) :*.py)
                               :karate/coreutils :bin/env)
            (b:run [:python3
                    :setup.py
                    :--freedom=partial
                    (.. :--prefix= b.prefix)
                    :--without-info-manual
                    :--without-man-manual
                    :--without-shared-cache
                    :--without-shell-completion
                    :install])
            (b:fix_interpreter [(.. b.prefix :/bin/ponysay)] :karate/coreutils
                               :bin/env))
 :strip (fn [b]
          nil)}
