;; scowl, ported from its plan.sh.
{:name :scowl
 :origin :karate
 :version :2017.08.24
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "Spell Checking Oriented Word Lists (SCOWL)"
 :upstream_url "http://wordlist.aspell.net/"
 :source {:url "http://downloads.sourceforge.net/wordlist/scowl-2017.08.24.tar.gz"
          :sha256 :ba84da9f5af06dbfded82236372545c06fd8162c3d48d11410bdfcf27ef3b0cd}
 :build (fn [b]
          nil)
 :install (fn [b]
            (b:mkdir (.. b.prefix :/share/dict))
            (each [_ p (ipairs (b:glob (b:join b.src :final) "*"))]
              (b:copy p (b:join (.. b.prefix :/share/dict/)
                                (: p :match "[^/]+$")))
              (b:chmod (b:join (.. b.prefix :/share/dict/)
                               (: p :match "[^/]+$"))
                       :444)))}
