(in-package :the-steward-website)

(defvar *http-server* nil
  "The Application's HTTP server.")

;;; Handlers

(tiny-routes:define-routes *app-routes*
  (tiny-routes:define-get "/" () (tiny-routes:ok "alive"))
  (tiny-routes:define-any "*" () (tiny-routes:not-found "not found")))

;;; App control functions

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
  (start-http-server *app-routes* :host host :port port :debug debug ))
