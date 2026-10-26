;; postfix, ported from its plan.sh.
;; postfix 3.11.7, the latest release on 2026-10-26: 3.3.2's source no longer downloads.
{:name "postfix"
 :origin "karate"
 :version "3.11.7"
 :targets ["x86_64-linux"]
 :maintainer "Strip Mall Karate Company"
 :license ["IPL-1.0"]
 :description "Postfix is a free and open-source mail transfer agent that routes and delivers electronic mail."
 :upstream_url "http://www.postfix.org/"
 :source {:url "https://postfix.mirrors.ovh.net/postfix-release/official/postfix-3.11.7.tar.gz" :sha256 "a2f3242345753448072177fae83c322a403c9263696996406201145dab8e8625"}
 :deps ["karate/coreutils" "karate/cyrus-sasl" "karate/db" "karate/glibc" "karate/libnsl" "karate/openssl" "karate/pcre" "karate/zlib" "karate/shadow" "karate/iana-etc"]
 :build_deps ["karate/make" "karate/gcc" "karate/sed" "karate/gawk" "karate/m4"]
 :bin_dirs ["bin" "sbin"]
 :svc {:user "root"}
 :build (fn [b]
          (var v-postfix-ccargs ["-DHAS_DB" (.. "-I" (b:path_for "db") "/include") "-DHAS_NIS" (.. "-I" (b:path_for "karate/libnsl") "/include") "-DUSE_TLS" (.. "-I" (b:path_for "karate/openssl") "/include") "-DUSE_SASL_AUTH" "-DUSE_CYRUS_SASL" (.. "-I" (b:path_for "karate/cyrus-sasl") "/include/sasl")])
          (b:log (.. "Setting POSTFIX_CCARGS=" (table.concat v-postfix-ccargs " ")))
          (var v-postfix-auxlibs ["-ldb" (.. "-L" (b:path_for "karate/db") "/lib") "-lnsl" (.. "-L" (b:path_for "karate/libnsl") "/lib") "-lresolv" (.. "-L" (b:path_for "karate/glibc") "/lib") "-lssl" "-lcrypto" (.. "-L" (b:path_for "karate/openssl") "/lib") "-lsasl2" (.. "-L" (b:path_for "karate/cyrus-sasl") "/lib")])
          (b:log (.. "Setting POSTFIX_AUXLIBS=" (table.concat v-postfix-auxlibs " ")))
          (b:run ["make" "makefiles" (.. "CCARGS=" (table.concat v-postfix-ccargs " ")) (.. "AUXLIBS=" (table.concat v-postfix-auxlibs " "))])
          (b:run ["make"]))
 :install (fn [b]
          (var v-command-directory "")
          (var v-config-directory "")
          (var v-daemon-directory "")
          (var v-data-directory "")
          (var v-install-root "")
          (var v-mail-spool-directory "")
          (var v-mailq-path "")
          (var v-manpage-directory "")
          (var v-meta-directory "")
          (var v-newaliases-path "")
          (var v-queue-directory "")
          (var v-sendmail-path "")
          (var v-shlib-directory "")
          (let [text (b:read (b:join b.src "postfix-install")) ends (= (text:sub -1) "\n") lines [] out []]
            (each [l (string.gmatch (if ends text (.. text "\n")) "(.-)\n")] (table.insert lines l))
            (each [n l (ipairs lines)]
              (var line l) (var deleted false) (local after [])
              (when (not deleted) (when (string.find line "^PATH=") (do (table.insert out " ") (set deleted true))))
              (when (not deleted) (table.insert out line))
              (each [_ x (ipairs after)] (table.insert out x)))
            (b:write (b:join b.src "postfix-install") (.. (table.concat out "\n") (if (and ends (> (length out) 0)) "\n" ""))))
          (b:run ["make" "non-interactive-package" (.. "install_root=" b.prefix) "daemon_directory=/sbin" "command_directory=/bin" "mailq_path=/bin/mailq" "sendmail_path=/bin/sendmail" "newaliases_path=/bin/newaliases" "shlib_directory=/lib" "meta_directory=/meta" "manpage_directory=/man" "config_directory=/config" "data_directory=/data/postfix" "mail_spool_directory=/data/spool" "queue_directory=/data/queue"])
          (b:remove (.. b.prefix "/config/main.cf.default")))}
