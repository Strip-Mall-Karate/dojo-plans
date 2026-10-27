;; caddy, ported from its plan.sh.
{:name :caddy
 :origin :karate
 :version :0.11.5
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "Fast, cross-platform HTTP/2 web server with automatic HTTPS"
 :upstream_url "https://caddyserver.com"
 :source {:url "https://github.com/mholt/caddy/releases/download/v0.11.5/caddy_v0.11.5_linux_amd64.tar.gz"
          :sha256 :d0ca02afdfd895b8e41051518e3f527185ac64ae6c55ca4e8de677b3d92b678b
          :dirname :caddy-v0.11.5}
 :deps [:karate/glibc]
 :bin_dirs [:bin]
 :svc {:run "caddy -conf /doj/svc/caddy/config/Caddyfile"}
 :exports {:port :http.port}
 :exposes [:port]
 :build (fn [b]
          nil)
 :install (fn [b]
            (b:copy (.. b.cache :/caddy) (.. b.prefix :/bin/caddy))
            (b:chmod (.. b.prefix :/bin/caddy) :755))}
