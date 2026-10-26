;; meson, ported from its plan.sh.
(var v-python-version "")
{:name "meson"
 :origin "karate"
 :version "0.46.1"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["Apache-2.0"]
 :description "The Meson Build System"
 :upstream_url "http://mesonbuild.com/"
 :source {:url "https://github.com/mesonbuild/meson/archive/0.46.1.tar.gz" :sha256 "2d917692d2cc194e12295f00469fbdf3c045e85d0295e5e59ced69115920ffa0"}
 :deps ["karate/python" "karate/ninja"]
 :build_deps ["karate/patch"]
 :bin_dirs ["bin"]
 :lib_dirs ["lib"]
 :prepare (fn [b]
          ;; From do_setup_environment.
          (var v-python "")
          (set v-python (.. (b:path_for "karate/python") "/bin/python"))
          (set v-python-version (b:capture [v-python "-c" "import sys; print(\"python{}.{}\".format(sys.version_info.major,sys.version_info.minor))"]))
          (b:run ["push_runtime_env" "PYTHONPATH" (b:capture [v-python "-c" "import site; print(\":\".join(site.getsitepackages()))"])])
          (b:run ["push_runtime_env" "PYTHONPATH" (.. b.prefix "/lib/" v-python-version "/site-packages")])
          (b:run ["unset" "python"])
          (b:mkdir (.. b.prefix "/lib/" v-python-version "/site-packages"))
          (b:run ["patch" "-p0" "-i" (.. b.plan_dir "/patches/000_fix_rpath.patch")]))
 :build (fn [b]
          (b:run ["python" "setup.py" "build"]))
 :install (fn [b]
          (b:run ["python" "setup.py" "install" (.. "--prefix=" b.prefix) "--optimize=1" "--skip-build"]))}
