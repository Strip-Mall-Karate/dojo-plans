;; consul, ported from its plan.sh.
{:name :consul
 :origin :karate
 :version :1.4.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:MPL-2.0]
 :description "Consul is a tool for service discovery, monitoring and configuration."
 :upstream_url "https://www.consul.io/"
 :source {:url "https://releases.hashicorp.com/consul/1.4.4/consul_1.4.4_linux_amd64.zip"
          :sha256 :d3bdf9817c7de9d83426d8c421eb3f37bf82c03c97860ef78fb56e148c4a9765
          :filename :consul-1.4.4_linux_amd64.zip}
 :build_deps [:karate/unzip]
 :bin_dirs [:bin]
 :exports {:port-dns :ports.dns
           :port-http :ports.http
           :port-serf_lan :ports.serf_lan
           :port-serf_wan :ports.serf_wan
           :port-server :ports.server}
 :exposes [:port-dns :port-http :port-serf_lan :port-serf_wan :port-server]
 :unpack (fn [b]
           (b:run [:unzip
                   :consul-1.4.4_linux_amd64.zip
                   :-d
                   (.. b.name "-" b.version)] {:cwd b.cache}))
 :build (fn [_b]
          nil)
 :install (fn [b]
            (b:copy (b:join b.src :consul) (.. b.prefix :/bin/consul))
            (b:chmod (.. b.prefix :/bin/consul) :755))}
