;;;; src/routes.lisp
(in-package :the-steward-website)

;; Route Definitions
(tiny-routes:define-routes *app-routes*
  (tiny-routes:define-get "/" ()
    (tiny-routes:ok (render-index-page)))
  (tiny-routes:define-get "/services" ()
    (tiny-routes:ok (render-services-page)))
  (tiny-routes:define-get "/about" ()
    (tiny-routes:ok (render-about-page)))
  (tiny-routes:define-get "/testimonials" ()
    (tiny-routes:ok (render-testimonials-page)))
  (tiny-routes:define-get "/contact" ()
    (tiny-routes:ok (render-contact-page)))
  (tiny-routes:define-any "*" ()
    (tiny-routes:not-found "not found")))

;; Route Dispatcher
(defun dispatch-routes (env)
  (funcall *app-routes* env))

