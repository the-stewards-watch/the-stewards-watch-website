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
  '((:name "Home Check"
     :icon "fa-house-user"
     :short-desc "A quick property check while you're away — no pet care needed"
     :description "A 15–30 minute check on your home. We'll collect mail and packages, water plants, adjust lights and blinds, and make sure everything is secure."
     :price "$25"
     :price-unit "/ visit"
     :price-note nil)
    (:name "Dog Walk"
     :icon "fa-walking"
     :short-desc "A dedicated 30-minute walk, bookable on its own"
     :description "A dedicated 30-minute walk for your dog, bookable any time on its own."
     :price "$30"
     :price-unit "/ walk"
     :price-note nil)
    (:name "Drop-In Visit"
     :icon "fa-door-open"
     :short-desc "One hour — feeding, walks, playtime, mail & more"
     :description "One hour in your home. Feeding, fresh water, a walk or playtime, plant care, and mail collection — all included. We care for dogs, cats, and other pets."
     :price "$50"
     :price-unit "/ visit"
     :price-note nil)
    (:name "Overnight Stay"
     :icon "fa-moon"
     :short-desc "Full pet care and home security, 8 PM to 8 AM — up to 2 pets"
     :description "We stay at your home from 8 PM to 8 AM, caring for up to two pets. Covers an evening walk and feeding, overnight care, a morning walk and feeding, plus mail, lighting, and keeping your home looking lived-in. Need us there during the day too? Add daytime coverage below."
     :price "$75"
     :price-unit "/ night"
     :price-note "Add daytime coverage (8 AM–8 PM) for $45/day")))

(defparameter *addons*
  '((:name "Daytime coverage during an overnight stay (8 AM–8 PM)" :price "+$45 / day" :icon "fa-sun")
    (:name "Each additional pet — walks & visits" :price "+$10 / visit" :icon "fa-paw")
    (:name "Each pet beyond two — overnight stays" :price "+$20 / night" :icon "fa-paw")
    (:name "Puppy (under 1 year) or pet needing special care" :price "+$10 / night or visit" :icon "fa-dog")
    (:name "Medication administration" :price "+$10 / visit" :icon "fa-pills")
    (:name "Last-minute booking (under 48 hrs notice)" :price "+$15 / booking" :icon "fa-clock")
    (:name "Major holiday surcharge" :price "+$15 / day" :icon "fa-calendar-alt")))

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
(defparameter +privacy-template+ (djula:compile-template* "privacy.html"))

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

(defun render-privacy-page ()
  (djula:render-template* +privacy-template+ nil
			  :title "The Steward"
			  :now (local-time:format-timestring nil (local-time:now) :format '(:year))))

(defparameter +404-template+ (djula:compile-template* "404.html"))

(defun render-404-page ()
  (djula:render-template* +404-template+ nil
			  :title "The Steward"
			  :now (local-time:format-timestring nil (local-time:now) :format '(:year))))
