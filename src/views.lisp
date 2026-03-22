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
;; Services data (single source of truth)
;; ---------------------------------------------------------------------------

(defparameter *services*
  '((:name "Drop-In Visit"
     :icon "fa-door-open"
     :short-desc "Up to one hour — feeding, walk, playtime, mail & more"
     :description "Up to one hour in your home. Includes feeding, a walk, playtime, fresh water, plant care, and mail collection. Pets optional."
     :price "$40"
     :price-unit "/ visit"
     :price-note nil)
    (:name "Dog Walk"
     :icon "fa-walking"
     :short-desc "A dedicated 30-minute walk, bookable on its own"
     :description "A dedicated 30-minute walk for your dog — nothing more, nothing less."
     :price "$30"
     :price-unit "/ walk"
     :price-note nil)
    (:name "Overnight Stay"
     :icon "fa-moon"
     :short-desc "Full pet care and home security overnight"
     :description "We stay at your home overnight. Includes all pet care, mail, lighting, and keeping your home looking lived-in while you're away."
     :price "$110"
     :price-unit "/ night"
     :price-note nil)
    (:name "Weekly Stay"
     :icon "fa-calendar-week"
     :short-desc "Six nights of care — best value for extended trips"
     :description "Six consecutive nights of overnight care — the best value for extended travel."
     :price "$550"
     :price-unit "/ week"
     :price-note "Save $110 — one night free")))

(defparameter *addons*
  '((:name "Each additional pet" :price "+$15")
    (:name "Puppy (under 1 year) or senior pet" :price "+$15")
    (:name "Medication administration" :price "Discussed at Meet & Greet")))

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
			  :services *services*
			  :now (local-time:format-timestring nil (local-time:now) :format '(:year))))

(defun render-services-page ()
  (djula:render-template* +services-template+ nil
			  :title "The Steward"
			  :active "services"
			  :services *services*
			  :addons *addons*
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
