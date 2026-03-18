;;;; views.lisp
(in-package :the-steward-website)

;; ---------------------------------------------------------------------------
;; Contact form helpers
;; ---------------------------------------------------------------------------

(defun get-form-param (params key)
  "Return the value for KEY from a Lack request-body-parameters alist."
  (cdr (assoc key params :test #'string=)))

(defun send-contact-email (name email phone message)
  "Send a contact form submission to the business inbox via the Resend API."
  (let ((body (cl-json:encode-json-alist-to-string
               `(("from"     . ,*contact-from*)
                 ("to"       . ,(vector *contact-to*))
                 ("reply_to" . ,email)
                 ("subject"  . ,(format nil "New inquiry from ~a" name))
                 ("text"     . ,(format nil "Name:    ~a~%Email:   ~a~%Phone:   ~a~%~%~a"
                                        name email
                                        (if (and phone (> (length phone) 0)) phone "—")
                                        message))))))
    (dexador:post "https://api.resend.com/emails"
                  :headers `(("Authorization" . ,(format nil "Bearer ~a" *resend-api-key*))
                              ("Content-Type"  . "application/json"))
                  :content body)))

;; ---------------------------------------------------------------------------
;; Template definitions
;; ---------------------------------------------------------------------------

;; Define template variables
(defparameter +base-template+ (djula:compile-template* "layout.html"))
(defparameter +index-template+ (djula:compile-template* "index.html"))
(defparameter +services-template+ (djula:compile-template* "services.html"))
(defparameter +about-template+ (djula:compile-template* "about.html"))
(defparameter +testimonials-template+ (djula:compile-template* "testimonials.html"))
(defparameter +contact-template+ (djula:compile-template* "contact.html"))

;; Page rendering functions
(defun render-index-page ()
  (djula:render-template* +index-template+ nil
			  :title "The Steward"
			  :active "home"
			  :now (local-time:format-timestring nil (local-time:now) :format '(:year))))

(defun render-services-page ()
  (djula:render-template* +services-template+ nil
			  :title "The Steward"
			  :active "services"
			  :now (local-time:format-timestring nil (local-time:now) :format '(:year))))

(defun render-about-page ()
  (djula:render-template* +about-template+ nil
			  :title "The Steward"
			  :active "about"
			  :now (local-time:format-timestring nil (local-time:now) :format '(:year))))

(defun render-testimonials-page ()
  (djula:render-template* +testimonials-template+ nil
			  :title "The Steward"
			  :active "testimonials"
			  :now (local-time:format-timestring nil (local-time:now) :format '(:year))))

(defun render-contact-page (&key sent error form-name form-email form-phone form-message)
  (djula:render-template* +contact-template+ nil
			  :title "The Steward"
			  :active "contact"
			  :sent sent
			  :error error
			  :form_name (or form-name "")
			  :form_email (or form-email "")
			  :form_phone (or form-phone "")
			  :form_message (or form-message "")
			  :now (local-time:format-timestring nil (local-time:now) :format '(:year))))

(defparameter +404-template+ (djula:compile-template* "404.html"))

(defun render-404-page ()
  (djula:render-template* +404-template+ nil
			  :title "The Steward"
			  :now (local-time:format-timestring nil (local-time:now) :format '(:year))))
