;;;; src/app.lisp
(in-package :the-steward-website)

(defvar *http-server* nil
  "The Application's HTTP server.")
(defvar *app-root* (asdf:system-source-directory :the-steward-website))

;; Resend API configuration — set these via environment variables before starting.
;; Sign up at resend.com (free tier: 3,000 emails/month, 100/day).
;; RESEND_API_KEY  — your Resend API key (required)
;; CONTACT_FROM    — verified sending address in your Resend account (required)
;; CONTACT_TO      — inbox that receives contact form submissions
(defvar *resend-api-key* (uiop:getenv "RESEND_API_KEY"))
(defvar *contact-from* (or (uiop:getenv "CONTACT_FROM") "The Stewards Watch <noreply@mail.thestewardswatch.com>"))
(defvar *contact-to* (or (uiop:getenv "CONTACT_TO") "thestewardswatch@gmail.com"))

;; Set up  Djula template directory
(djula:add-template-directory (asdf:system-relative-pathname "the-steward-website" "templates/"))

(defun build-app ()
  (lack:builder :session
		(:static :path "/static/"
			 :root (merge-pathnames #p"static/" *app-root*))
		#'dispatch-routes))


(defun stop-http-server ()
  (when *http-server*
    (clack:stop *http-server*)
    (setf *http-server* nil)))

(defun start-http-server (handler &key host port debug)
  (let ((port (or port 8080)))
    (stop-http-server)
    (setf *http-server*
	  (clack:clackup handler :address host :port port :debug debug))
    (format t "Successfully initialized server on port ~a~%" port)))

(defun stop-app ()
  (stop-http-server))

(defun start-app (&key (host "127.0.0.1") (port 8080) (debug t))
  (start-http-server (build-app) :host host :port port :debug debug ))
