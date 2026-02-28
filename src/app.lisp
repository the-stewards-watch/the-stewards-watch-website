;;;; src/app.lisp
(in-package :the-steward-website)

(defvar *http-server* nil
  "The Application's HTTP server.")
(defvar *app-root* (asdf:system-source-directory :the-steward-website))

;; Resend API configuration — read from environment variables at startup.
;; Sign up at resend.com (free tier: 3,000 emails/month, 100/day).
;; RESEND_API_KEY  — your Resend API key (required)
;; CONTACT_FROM    — verified sending address in your Resend account (required)
;; CONTACT_TO      — inbox that receives contact form submissions
(defvar *resend-api-key* nil)
(defvar *contact-from* nil)
(defvar *contact-to* nil)

;; Set up Djula template directory
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
	  (clack:clackup handler :server :woo :address host :port port :debug debug))
    (format t "Successfully initialized server on port ~a~%" port)))

(defun stop-app ()
  (stop-http-server))

(defun main ()
  "Production entry point used by Docker/systemd.
Starts the server, installs a SIGTERM handler for graceful shutdown,
then blocks so the process stays alive."
  (start-app)
  (sb-sys:enable-interrupt sb-unix:sigterm
    (lambda (signal code scp)
      (declare (ignore signal code scp))
      (format t "~&Received SIGTERM — shutting down.~%")
      (stop-app)
      (sb-ext:exit 0)))
  (loop (sleep 60)))

(defun start-app (&key
		    (host (or (uiop:getenv "HOST") "0.0.0.0"))
		    (port (let ((p (uiop:getenv "PORT")))
			    (if p (parse-integer p) 8080)))
		    (debug nil))
  ;; Read Resend configuration from the environment at startup so that
  ;; env vars set in Docker / systemd / the shell are always picked up.
  (setf *resend-api-key* (uiop:getenv "RESEND_API_KEY"))
  (setf *contact-from* (or (uiop:getenv "CONTACT_FROM")
			    "The Stewards Watch <contact@mail.thestewardswatch.com>"))
  (setf *contact-to* (or (uiop:getenv "CONTACT_TO") "thestewardswatch@gmail.com"))
  (start-http-server (build-app) :host host :port port :debug debug))
