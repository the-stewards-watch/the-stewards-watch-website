;;;; src/app.lisp
(in-package :the-steward-website)

(defvar *http-server* nil
  "The Application's HTTP server.")
(defvar *app-root* (asdf:system-source-directory :the-steward-website))

;; SMTP configuration — set these via environment variables before starting.
;; For Gmail: generate an App Password at myaccount.google.com/apppasswords
(defvar *smtp-host* (or (uiop:getenv "SMTP_HOST") "smtp.gmail.com"))
(defvar *smtp-port* (parse-integer (or (uiop:getenv "SMTP_PORT") "587")))
(defvar *smtp-user* (or (uiop:getenv "SMTP_USER") "thestewardswatch@gmail.com"))
(defvar *smtp-password* (uiop:getenv "SMTP_PASSWORD"))
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
