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
  (tiny-routes:define-post "/contact" (request)
    (let* ((req    (lack.request:make-request request))
           (params (lack.request:request-body-parameters req))
           (name    (get-form-param params "name"))
           (email   (get-form-param params "email"))
           (phone   (get-form-param params "phone"))
           (message (get-form-param params "message")))
      (if (and name email message
               (> (length name) 0)
               (> (length email) 0)
               (> (length message) 0))
          (handler-case
              (progn
                (send-contact-email name email phone message)
                (tiny-routes:ok (render-contact-page :sent t)))
            (error ()
              (tiny-routes:ok (render-contact-page :error t))))
          (tiny-routes:ok (render-contact-page :error t)))))
  (tiny-routes:define-any "*" ()
    (tiny-routes:not-found "not found")))

;; Route Dispatcher
(defun dispatch-routes (env)
  (funcall *app-routes* env))

