;; tzdata, ported from its plan.sh.
{:name "tzdata"
 :origin "karate"
 :version "2018g"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["gpl"]
 :description "Sources for time zone and daylight saving time data"
 :upstream_url "http://www.iana.org/time-zones"
 :source {:url "https://www.iana.org/time-zones/repository/releases/tzdata2018g.tar.gz" :sha256 "02dfde534872f6513ae4553a3388fdae579441e31b862ea99170dfc447f46a16"}
 :unpack (fn [b]
          (b:mkdir (.. b.cache "/" (.. b.name "-" b.version)))
          (b:run ["tar" "xf" (.. b.cache "/tzdata2018g.tar.gz")] {:cwd (.. b.cache "/" (.. b.name "-" b.version))}))
 :build (fn [b]
          nil)
 :install (fn [b]
          (b:run ["zic" "-y" "./yearistype" "-d" (.. b.prefix "/share/zoneinfo") "africa antarctica asia australasia europe northamerica southamerica pacificnew etcetera backward systemv factory"])
          (b:run ["zic" "-y" "./yearistype" "-d" (.. b.prefix "/share/zoneinfo/posix") "africa antarctica asia australasia europe northamerica southamerica pacificnew etcetera backward systemv factory"])
          (b:run ["zic" "-y" "./yearistype" "-d" (.. b.prefix "/share/zoneinfo/right") "-L" "leapseconds" "africa antarctica asia australasia europe northamerica southamerica pacificnew etcetera backward systemv factory"])
          (b:run ["zic" "-y" "./yearistype" "-d" (.. b.prefix "/share/zoneinfo") "-p" "America/New_York"])
          (b:copy (b:join b.src "iso3166.tab") (b:join (.. b.prefix "/share/zoneinfo/") (: (b:join b.src "iso3166.tab") :match "[^/]+$")))
          (b:chmod (b:join (.. b.prefix "/share/zoneinfo/") (: (b:join b.src "iso3166.tab") :match "[^/]+$")) "444")
          (b:copy (b:join b.src "zone1970.tab") (b:join (.. b.prefix "/share/zoneinfo/") (: (b:join b.src "zone1970.tab") :match "[^/]+$")))
          (b:chmod (b:join (.. b.prefix "/share/zoneinfo/") (: (b:join b.src "zone1970.tab") :match "[^/]+$")) "444")
          (b:copy (b:join b.src "zone.tab") (b:join (.. b.prefix "/share/zoneinfo/") (: (b:join b.src "zone.tab") :match "[^/]+$")))
          (b:chmod (b:join (.. b.prefix "/share/zoneinfo/") (: (b:join b.src "zone.tab") :match "[^/]+$")) "444"))}
