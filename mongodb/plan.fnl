;; mongodb, ported from its plan.sh.
{:name :mongodb
 :origin :karate
 :version :3.6.4
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:AGPL-3.0]
 :description "High-performance, schema-free, document-oriented database"
 :upstream_url "https://www.mongodb.com/"
 :source {:url "https://fastdl.mongodb.org/src/mongodb-src-r3.6.4.tar.gz"
          :sha256 :1a9697c3ad2f5545b5160d5e32d5f3c0f6f0a3371ceb9fa85961aec513acd7ac
          :filename :mongodb-src-r3.6.4.tar.gz
          :dirname :mongodb-src-r3.6.4}
 :deps [:karate/coreutils :karate/gcc-libs :karate/glibc :karate/openssl]
 :build_deps [:karate/gcc
              :karate/glibc
              :karate/python2
              :karate/scons/2.5.1
              :karate/openssl
              :karate/patchelf]
 :bin_dirs [:bin]
 :lib_dirs [:lib]
 :include_dirs [:include]
 :svc {:run "mongod --config /doj/svc/mongodb/config/mongod.conf"}
 :exports {:port :mongod.net.port}
 :exposes [:port]
 :prepare (fn [b]
            (b:env :CC (.. (b:path_for :karate/gcc) :/bin/gcc))
            (b:env :CXX (.. (b:path_for :karate/gcc) :/bin/g++))
            (var v-incpath
                 (pick-values 1
                              (string.gsub (or (b:getenv :CFLAGS) "") "%-I" "")))
            (set v-incpath (pick-values 1 (string.gsub v-incpath " " "', '")))
            (var v-libpath
                 (pick-values 1
                              (string.gsub (or (b:getenv :LDFLAGS) "") "%-L" "")))
            (set v-libpath (pick-values 1 (string.gsub v-libpath " " "', '")))
            (b:env :LIBPATH v-libpath)
            (b:env :INCPATH v-incpath)
            (let [text (b:read (b:join b.src :SConstruct))
                  ends (= (text:sub -1) "\n")
                  lines []
                  out []]
              (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")]
                (table.insert lines l))
              (each [n l (ipairs lines)]
                (var line l)
                (local deleted false)
                (local after [])
                (when (not deleted)
                  (when (= n 891)
                    (set line
                         (pick-values 1
                                      (string.gsub line :**envDict
                                                   (.. "ENV = os.environ, CPPPATH = ['"
                                                       (pick-values 1
                                                                    (v-incpath:gsub "%%"
                                                                                    "%%%%"))
                                                       "'], LIBPATH = ['"
                                                       (pick-values 1
                                                                    (v-libpath:gsub "%%"
                                                                                    "%%%%"))
                                                       "'], CFLAGS = os.environ['CFLAGS'], CXXFLAGS = os.environ['CXXFLAGS'], LINKFLAGS = os.environ['LDFLAGS'], CC = os.environ['CC'], CXX = os.environ['CXX'], PATH = os.environ['PATH'], **envDict"))))))
                (when (not deleted) (table.insert out line))
                (each [_ x (ipairs after)] (table.insert out x)))
              (b:write (b:join b.src :SConstruct)
                       (.. (table.concat out "\n")
                           (if (and ends (> (length out) 0))
                               "\n"
                               "")))))
 :build (fn [b]
          (b:run [:pip :install :typing :pyyaml :cheetah3])
          (b:run [:scons
                  :core
                  :--disable-warnings-as-errors
                  (.. :--prefix= b.prefix)
                  :--ssl
                  (.. :-j (tostring b.jobs))]))
 :install (fn [b]
            (b:run [:scons
                    :install
                    :--disable-warnings-as-errors
                    (.. :--prefix= b.prefix)
                    :--ssl])
            (b:run [:patchelf
                    :--set-rpath
                    (or (b:getenv :LD_RUN_PATH) "")
                    (.. b.prefix :/bin/mongod)])
            (b:run [:patchelf
                    :--set-rpath
                    (or (b:getenv :LD_RUN_PATH) "")
                    (.. b.prefix :/bin/mongo)])
            (b:run [:patchelf
                    :--set-rpath
                    (or (b:getenv :LD_RUN_PATH) "")
                    (.. b.prefix :/bin/mongoperf)])
            (b:run [:patchelf
                    :--set-rpath
                    (or (b:getenv :LD_RUN_PATH) "")
                    (.. b.prefix :/bin/mongos)])
            (b:fix_interpreter [(.. b.prefix :/bin/install_compass)]
                               :karate/coreutils :bin/env))
 :strip (fn [_b]
          nil)}
