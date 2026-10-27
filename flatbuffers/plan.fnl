;; flatbuffers, ported from its plan.sh.
{:name :flatbuffers
 :origin :karate
 :version :1.10.0
 :targets [:x86_64-linux]
 :maintainer "Strip Mall Karate Company"
 :license [:Apache-2.0]
 :description "FlatBuffers is an efficient cross platform serialization library for C++,
C#, C, Go, Java, JavaScript, PHP, and Python. It was originally created at
Google for game development and other performance-critical applications."
 :upstream_url "http://google.github.io/flatbuffers/index.html"
 :source {:url "https://github.com/google/flatbuffers/archive/v1.10.0.tar.gz"
          :sha256 :3714e3db8c51e43028e10ad7adffb9a36fc4aa5b1a363c2d0c4303dd1be59a7c}
 :build_deps [:karate/cmake :karate/gcc :karate/make]
 :lib_dirs [:lib64]
 :include_dirs [:include]
 :prepare (fn [b]
            (b:env :LD_LIBRARY_PATH (.. (b:path_for :gcc) :/lib)))
 :build (fn [b]
          (b:run [:cmake
                  :-G
                  "Unix Makefiles"
                  (.. :-DCMAKE_INSTALL_PREFIX= b.prefix)
                  (.. :-DCMAKE_CXX_FLAGS= (or (b:getenv :CXXFLAGS) ""))])
          (b:run [:make]))
 :check (fn [b]
          (b:run [:./flattests]))}
