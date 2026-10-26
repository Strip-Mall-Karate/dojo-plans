;; Scaffolding for Go applications that build in a GOPATH.
;;
;; The package's source goes at $GOPATH/src/<import path>, where Go finds its
;; own packages and those it vendors. The GOPATH is the build's own, in the
;; cache. Settings, in the plan's `:scaffolding {:settings ...}`:
;;
;;   :import_path  where the source goes in the GOPATH. Without it: the
;;                 github.com/<owner>/<repo> of a GitHub archive source, else
;;                 <base_path>/<name>.
;;   :base_path    for a plan without a source, whose own directory is the
;;                 application: the import path's start (localhost/user).
;;
;; Plans that build their own way read `(b.scaffolding.gopath b)` and
;; `(b.scaffolding.pkg_path b)` and `(b.scaffolding.goarch b)`, and call
;; `(b.scaffolding.env b)` first.

(fn settings [b]
  (or b.scaffolding_settings {}))

(fn import_path [b]
  (let [s (settings b)
        url (and b.source b.source.url)
        github (and url (url:match "^https?://github%.com/([^/]+/[^/]+)/archive/"))]
    (or s.import_path
        (and github (.. "github.com/" github))
        (.. (or s.base_path "localhost/user") "/" b.name))))

(fn gopath [b]
  (b:join b.cache (.. b.name "-gopath")))

(fn pkg_path [b]
  (b:join (gopath b) "src" (import_path b)))

(fn goarch [b]
  ;; Go's name for the target's architecture.
  (or (. {:x86_64 "amd64" :aarch64 "arm64"} b.arch) b.arch))

(fn env [b]
  ;; GOPATH, its bin first on PATH (where `go install` and `go get` put
  ;; tools), and cgo's flags.
  (let [path (gopath b)
        bin (b:join path "bin")
        current (or (b:getenv "PATH") "")]
    (b:env "GOPATH" path)
    (when (not (: (.. ":" current ":") :find (.. ":" bin ":") 1 true))
      (b:env "PATH" (.. bin ":" current)))
    ;; cgo reads its own flags, not the C compiler's: the dependencies' headers
    ;; and libraries reach it through these.
    (each [_ [cgo flags] (ipairs [["CGO_CFLAGS" "CFLAGS"] ["CGO_LDFLAGS" "LDFLAGS"]])]
      (when (and (not (b:getenv cgo)) (b:getenv flags))
        (b:env cgo (b:getenv flags))))))

{:metadata (fn [plan settings]
             {:bin_dirs ["bin"]})
 :gopath gopath
 :pkg_path pkg_path
 :import_path import_path
 :env env
 :goarch goarch
 :download (fn [b]
             (env b)
             (b.default.download b))
 :unpack (fn [b]
           ;; The source's tree at its import path; a plan without a source is
           ;; its own directory, linked there.
           (env b)
           (let [dest (pkg_path b)]
             (b:remove dest)
             (if b.source
                 (do
                   (b:mkdir dest)
                   (b:run ["tar" "xf" (b:join b.cache b.source.filename) "--strip-components=1" "--no-same-owner"]
                          {:cwd dest}))
                 (do
                   (b:mkdir (dest:match "^(.*)/[^/]+$"))
                   (b:symlink b.src dest)))))
 :build (fn [b]
          (env b)
          (let [dir (pkg_path b)]
            (if (b:exists (b:join dir "Makefile"))
                (b:run ["make"] {:cwd dir})
                (b:run ["go" "build"] {:cwd dir}))))
 :install (fn [b]
            (env b)
            (let [dir (pkg_path b)
                  bin (b:join (gopath b) "bin")]
              (b:run ["go" "install"] {:cwd dir})
              (each [_ f (ipairs (b:glob bin "*"))]
                (b:copy f (b:join b.prefix "bin" (f:match "[^/]+$"))))))}
