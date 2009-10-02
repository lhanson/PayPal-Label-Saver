(define (script-fu-process-shipping-label infile)
    (let* ( (image    (car (gimp-file-load RUN-NONINTERACTIVE infile infile)))
				  ; the initial layer is page 2, delete it
          (drawable (car (gimp-image-active-drawable image)))
					(gimp-drawable-delete drawable)
					; get active drawable from remaining layer
          (drawable (car (gimp-image-active-drawable image)))
					(layer)
					(len (string-length infile))
					(extension (substring infile (- len 4) len))
					(outfile)
		 )
		 ; Select the label section of the image
		 (gimp-rect-select image 120 70 614 440 CHANNEL-OP-REPLACE FALSE 0)
		 ; invert and delete everything else
		 (gimp-selection-invert image)
		 (gimp-edit-clear drawable)
		 ; invert to get the label again
		 (gimp-selection-invert image)
		 (gimp-edit-cut drawable)
		 (gimp-selection-clear image)
		 (gimp-edit-paste drawable TRUE)
    	 (set! layer (car (gimp-image-get-floating-sel image)))
		 (gimp-layer-translate layer 0 -250)
		 (gimp-floating-sel-anchor layer)
		 ; if the filename already ends in .png, name the output something different
		 ; otherwise save it as a png
		 (if (string-ci=? extension ".png")
			 (set! outfile (string-append (substring infile 0 (- len 4)) "-processed.png"))
			 (set! outfile (string-append (substring infile 0 (- len 4)) ".png"))
		 ) 
		 ;(gimp-message (string-append "Input filename: " (string-append infile (string-append ", output filename: " outfile))))
		 (gimp-file-save  RUN-NONINTERACTIVE image drawable outfile outfile)
		 ; for debugging...
		 ;(gimp-image-clean-all image)
		 ;(gimp-display-new image)
    )
)

(script-fu-register "script-fu-process-shipping-label"
          _"Process PayPal Labels"
          "Crops and transforms PDF labels saved from PayPal in a manner which allows them to be printed on half-sheet label paper."
          "Lyle Hanson"
          "2009"
          "January 21, 2009"
          ""
          SF-STRING "Label file" "C:\\USPS_Label.pdf")
(script-fu-menu-register "script-fu-process-shipping-label" "<Toolbox>/Xtns/User Scripts/")
