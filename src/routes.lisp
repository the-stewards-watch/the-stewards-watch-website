;;;; src/routes.lisp
(in-package :the-steward-website)

;; Route Definitions
(tiny-routes:define-routes *app-routes*
  (tiny-routes:define-get "/" ()
    (tiny-routes:ok (render-index-page)))
  (tiny-routes:define-any "*" ()
    (tiny-routes:not-found "not found")))

;; Route Dispatcher
(defun dispatch-routes (env)
  (funcall *app-routes* env))
