;;;; views.lisp
(in-package :the-steward-website)

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

(defun render-contact-page ()
  (djula:render-template* +contact-template+ nil
			  :title "The Steward"
			  :active "contact"
			  :now (local-time:format-timestring nil (local-time:now) :format '(:year))))
