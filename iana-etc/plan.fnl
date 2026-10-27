;; iana-etc, ported from its plan.sh.
;; iana-etc 20261022, the latest release on 2026-10-26, from the maintained project: the original
;; (sethwklein.net 2.30) is gone. Releases are the generated files themselves, so there is nothing
;; to build; etc/services and etc/protocols are where the packages that use them look.
{:name :iana-etc
 :origin :karate
 :version :20261022
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MIT]
 :description "The iana-etc package provides the Unix/Linux /etc/services and /etc/protocols files."
 :upstream_url "https://github.com/Mic92/iana-etc"
 :source {:url "https://github.com/Mic92/iana-etc/releases/download/20261022/iana-etc-20261022.tar.gz"
          :sha256 :8ea9429c691634056ad8c292cf94df8e4cc5e828dceef658490bcbab132dee7c}
 :build (fn [b])
 :install (fn [b]
            (b:mkdir (.. b.prefix :/etc))
            (b:copy (b:join b.src :services) (.. b.prefix :/etc/services))
            (b:copy (b:join b.src :protocols) (.. b.prefix :/etc/protocols)))}
