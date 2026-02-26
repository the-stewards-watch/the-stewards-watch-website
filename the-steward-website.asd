(asdf:defsystem #:the-steward-website
  :description "Website for house sitting business"
  :author "Matthew Bestard m.bestard@gmail.com"
  :license "GPL"
  :version "0.1.0"
  :depends-on (#:clack
	       #:tiny-routes
	       #:djula
	       #:mito
	       #:postmodern
	       #:alexandria
	       #:cl-json
	       #:dexador)
  :components ((:module "src"
		:components ((:file "package")
			     (:file "app")
			     (:file "routes")
			     (:file "views"))))
  :build-operation "program-op"
  :build-pathname "the-steward-website"
  :entry-point "the-steward-website:start-app")
