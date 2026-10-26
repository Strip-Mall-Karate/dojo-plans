;; openresty, ported from its plan.sh.
(fn use-dependency-path [b path replacement]
  ;; The source project's studio linked a dependency's tool to `path` for the
  ;; build. A Dojo build writes nothing outside itself, so the build's scripts
  ;; name the dependency's tool instead.
  (each [_ f (ipairs (b:find b.src "*"))]
    (let [name (: f :match "[^/]+$")]
      (when (and (or (: name :match "^configure") (: name :match "^Makefile") (: name :match "^ltmain")
                     (: name :match "%.in$") (: name :match "%.am$") (: name :match "%.ac$")
                     (: name :match "%.m4$") (: name :match "%.mk$") (: name :match "%.sh$")
                     (: name :match "%.pl$") (: name :match "%.py$"))
                 (not (b:exists (b:join f "."))))
        (let [text (b:read f)
              escaped (pick-values 1 (: path :gsub "[%^%$%(%)%%%.%[%]%*%+%-%?]" "%%%0"))
              (fixed n) (: text :gsub escaped (pick-values 1 (: replacement :gsub "%%" "%%%%")))]
          (when (> n 0) (b:write f fixed)))))))
{:name "openresty"
 :origin "karate"
 :version "1.13.6.2"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["BSD-2-Clause"]
 :description "Scalable Web Platform by Extending NGINX with Lua"
 :upstream_url "http://openresty.org/"
 :source {:url "https://openresty.org/download/openresty-1.13.6.2.tar.gz" :sha256 "946e1958273032db43833982e2cec0766154a9b5cb8e67868944113208ff2942"}
 :deps ["karate/glibc" "karate/gcc-libs" "karate/libxml2" "karate/libxslt" "karate/zlib" "karate/bzip2" "karate/openssl" "karate/pcre" "karate/coreutils" "karate/perl" "karate/which"]
 :build_deps ["karate/gcc" "karate/make"]
 :bin_dirs ["bin" "nginx/sbin" "luajit/bin"]
 :lib_dirs ["lib"]
 :include_dirs ["include"]
 :svc {:user "root"}
 :exports {"port" "http.listen.port"}
 :exposes ["port"]
 :prepare (fn [b]
          (use-dependency-path b "/usr/bin/env" (b:path_for "coreutils" "bin/env")))
 :build (fn [b]
          (b:run ["./configure" (.. "--prefix=" b.prefix) "--user=doj" "--group=doj" "--http-log-path=/dev/stdout" "--error-log-path=stderr" "--with-ipv6" "--with-debug" "--with-pcre" "--with-md5-asm" "--with-pcre-jit" "--with-sha1-asm" "--with-file-aio" "--with-luajit" "--with-stream=dynamic" "--with-mail=dynamic" "--with-http_gunzip_module" "--with-http_gzip_static_module" "--with-http_realip_module" "--with-http_v2_module" "--with-http_ssl_module" "--with-http_stub_status_module" "--with-http_addition_module" "--with-http_degradation_module" "--with-http_flv_module" "--with-http_mp4_module" "--with-http_secure_link_module" "--with-http_sub_module" "--with-http_slice_module" (.. "--with-cc-opt=" (or (b:getenv "CFLAGS") "")) (.. "--with-ld-opt=" (or (b:getenv "LDFLAGS") "")) "--without-http_ssi_module" "--without-mail_smtp_module" "--without-mail_imap_module" "--without-mail_pop3_module" (.. "-j" (tostring b.jobs))])
          (b:run ["make" (.. "-j" (tostring b.jobs))]))
 :install (fn [b]
          (b:run ["make" "install"])
          (b:fix_interpreter (b:glob (.. b.prefix "/bin") "*") "karate/coreutils" "bin/env"))
 :strip (fn [b]
          (b.default.strip b)
          ;; From do_end.
          )}
