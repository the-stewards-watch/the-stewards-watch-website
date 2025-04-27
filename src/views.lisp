;;;; views.lisp
(in-package :the-steward-website)

;; Define template variables
(defparameter +base-template+ (djula:compile-template* "layout.html"))
(defparameter +index-template+ (djula:compile-template* "index.html"))

;; Page rendering functions
(defun render-index-page ()
  (djula:render-template* +index-template+ nil
			  :title "The Steward"))


