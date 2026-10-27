;; fennel-ls's settings, which smk lint runs over the plans.
;; Five style lints are off: the Fennel tools/port generates trips them
;; about 1,700 times, and SMK-432 turns them back on once it does not.
{:lints {:unnecessary-method false
         :unused-definition false
         :var-never-set false
         :nested-associative-operator false
         :unnecessary-unary false}}
