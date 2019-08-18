;;;; Grassi Marco 829664

;;; turtle representation (:turtle x y orientation color pen)
;;;                                [0,360)           T/NIL
;;; graphical operation stack ((:line x1 y1 x2 y2 color), ...)

;;; each operation apart from dump svg returns the new state of the turtle and the opStack

(defun get-turtle-x (turtle)
  (nth 1 turtle))

(defun get-turtle-y (turtle)
  (nth 2 turtle))

(defun get-turtle-orientation (turtle)
  (nth 3 turtle))

(defun get-turtle-color (turtle)
  (nth 4 turtle))

(defun get-turtle-pen (turtle)
  (nth 5 turtle))

;;; returns true if turtle is in a valid format, false otherwise
;;; (:turtle 0 0 deg color T/nil)
(defun is-turtle-valid (turtle)
  (if
   (and (listp turtle)
        (eq ':turtle (nth 0 turtle))
        (integerp (get-turtle-x turtle))
        (integerp (get-turtle-y turtle))
        (and (integerp (get-turtle-orientation turtle))
             (< (get-turtle-orientation turtle ) 360)
             (>= (get-turtle-orientation turtle ) 0))
        (if (not (null (member (get-turtle-color turtle) '(:black :white :red :cyan :purple :green :blue :yellow)))) T nil)
        (typep (get-turtle-pen turtle) 'boolean))
   T nil))

;;;returns true if each line in the opstack is correctly formatted, false otherwise
(defun is-opstack-valid (opstack)
  (if (and (listp opstack)
           (or (null opstack)
               (every (lambda (line)
                        (if (and (eq (nth 0 line) :line)
                                 (integerp (nth 1 line))
                                 (integerp (nth 2 line))
                                 (integerp (nth 3 line))
                                 (integerp (nth 4 line))
                                 (not (null (member (nth 5 line) '(:black :white :red :cyan :purple :green :blue :yellow)))))
                            T))
                      opstack)))
      T))

(defun pencolor (turtle opstack color)
  (if (and (is-turtle-valid turtle)
           (is-opstack-valid opstack)
           (not (null (member color '(:black :white :red :cyan :purple :green :blue :yellow)))))
      (values (list :turtle (get-turtle-x turtle) (get-turtle-y turtle)
                    (get-turtle-orientation turtle)
                    color
                    (get-turtle-pen turtle))
              opstack)))

(defun pendown (turtle opstack)
  (if (and (is-turtle-valid turtle)
           (is-opstack-valid opstack))
      (values (list :turtle (get-turtle-x turtle) (get-turtle-y turtle)
                    (get-turtle-orientation turtle)
                    (get-turtle-color turtle)
                    T)
              opstack)))

(defun penup (turtle opstack)
  (if (and (is-turtle-valid turtle)
           (is-opstack-valid opstack))
      (values (list :turtle (get-turtle-x turtle) (get-turtle-y turtle)
                    (get-turtle-orientation turtle)
                    (get-turtle-color turtle)
                    nil)
              opstack)))

(defun setx (turtle opstack x)
  (if (and (integerp x)
           (is-turtle-valid turtle))
      (values (list :turtle x (get-turtle-y turtle)
                    (get-turtle-orientation turtle)
                    (get-turtle-color turtle)
                    (get-turtle-pen turtle))
              opstack)))

(defun sety (turtle opstack y)
  (if (and (integerp y)
           (is-turtle-valid turtle)
           (is-opstack-valid opstack))
      (values (list :turtle (get-turtle-x turtle) y
                    (get-turtle-orientation turtle)
                    (get-turtle-color turtle)
                    (get-turtle-pen turtle))
              opstack)))

(defun setheading (turtle opstack degrees)
  (if (and (integerp degrees)
           (and (< degrees 360)
                (>= degrees 0))
           (is-turtle-valid turtle)
           (is-opstack-valid opstack))
      (values (list :turtle (get-turtle-x turtle) (get-turtle-y turtle)
                    degrees
                    (get-turtle-color turtle)
                    (get-turtle-pen turtle))
              opstack)))

(defun left (turtle opstack degrees)
  (if (and (integerp degrees)
           (is-turtle-valid turtle)
           (>= degrees 0)
           (is-opstack-valid opstack))
      (values (list :turtle (get-turtle-x turtle) (get-turtle-y turtle)
                    (mod (- (get-turtle-orientation turtle) degrees) 360)
                    (get-turtle-color turtle)
                    (get-turtle-pen turtle))
              opstack)))

(defun right (turtle opstack degrees)
  (if (and (integerp degrees)
           (is-turtle-valid turtle)
           (is-opstack-valid opstack)
           (>= degrees 0))
      (values (list :turtle (get-turtle-x turtle) (get-turtle-y turtle)
                    (mod (+ (get-turtle-orientation turtle) degrees) 360)
                    (get-turtle-color turtle)
                    (get-turtle-pen turtle))
              opstack)))
           
;;; converts from 'turtle degrees' to degrees     
(defun turtledeg-to-mathdeg (turtledeg)
  (mod (- 90 turtledeg) 360))

;;;converts from degrees to radians
(defun mathdeg-to-rad (mathdeg)
  (* mathdeg (/ pi 180)))

;;; returns the distance moved
(defun distance-x (turtle distance)
  (if (and (is-turtle-valid turtle)
           (integerp distance)
           (>= distance 0))
      (nth-value 0 (floor (+ (* distance (sin (mathdeg-to-rad
                                               (get-turtle-orientation turtle))))
                             1/2))))) ; round to nearest integer

;;; returns the distance moved
(defun distance-y (turtle distance)
  (if (and (is-turtle-valid turtle)
           (integerp distance)
           (>= distance 0))
      (nth-value 0 (floor (+ (* distance (cos (mathdeg-to-rad
                                               (get-turtle-orientation turtle))))
                             1/2))))) ; round to nearest integer

(defun forward (turtle opstack distance)
  (if (and (is-turtle-valid turtle)
           (is-opstack-valid opstack)
           (integerp distance)
           (>= distance 0))
      (values (list :turtle
                    (+ (get-turtle-x turtle) (distance-x turtle distance))
                    (- (get-turtle-y turtle) (distance-y turtle distance))
                    (get-turtle-orientation turtle)
                    (get-turtle-color turtle)
                    (get-turtle-pen turtle))
              (if (get-turtle-pen turtle)  ;if the pen is down add to opstack              
                  (cons (list :line (get-turtle-x turtle) (get-turtle-y turtle)
                              (+ (get-turtle-x turtle) (distance-x turtle distance))
                              (- (get-turtle-y turtle) (distance-y turtle distance))
                              (get-turtle-color turtle))
                        opstack)
                  opstack))))

(defun back (turtle opstack distance)
  (if (and (is-turtle-valid turtle)
           (is-opstack-valid opstack)
           (integerp distance)
           (>= distance 0))
      (values (list :turtle
                    (- (get-turtle-x turtle) (distance-x turtle distance))
                    (+ (get-turtle-y turtle) (distance-y turtle distance))
                    (get-turtle-orientation turtle)
                    (get-turtle-color turtle)
                    (get-turtle-pen turtle))
              (if (get-turtle-pen turtle)  ;if the pen is down add to opstack
                  (cons (list :line (get-turtle-x turtle) (get-turtle-y turtle)
                              (- (get-turtle-x turtle) (distance-x turtle distance))
                              (+ (get-turtle-y turtle) (distance-y turtle distance))
                              (get-turtle-color turtle))
                        opstack)
                  opstack))))

(defun home (turtle opstack)
  (if (and (is-turtle-valid turtle)
      (is-opstack-valid opstack))
      (values (list :turtle 0 0 0 (get-turtle-color turtle) (get-turtle-pen turtle))
              (if (get-turtle-pen turtle) ;if the pen is down add to opstack
                  (cons (list :line (get-turtle-x turtle) (get-turtle-y turtle)
                              0 0 (get-turtle-color turtle))
                        opstack)
                  opstack))))
                      

(defun dump-svg (filename opstack)
  (cond ((and (stringp filename)
              (not (null opstack))
              (is-opstack-valid opstack))
         (let ((out (open (concatenate 'string filename ".svg") ; create file
                          :direction :output
                          :if-exists :supersede
                          :if-does-not-exist :create)))    
           (format out "<?xml version=\"1.0\" encoding=\"UTF-8\"?> ~%")
           (multiple-value-bind (width height min-x min-y) (calc-viewbox opstack)
             (format out "<svg width=\"~A\" height=\"~A\" viewBox=\"~A ~A ~A ~A\""
                     width height min-x min-y width height))
           (format out " xmlns=\"http://www.w3.org/2000/svg\">~%")
           (mapc #'(lambda (line)
                     (format out "<line x1=\"~A\" y1=\"~A\" x2=\"~A\" y2=\"~A\" stroke=\"~A\" stroke-width=\"1\"/>~%"
                             (nth 1 line)
                             (nth 2 line)
                             (nth 3 line)
                             (nth 4 line)
                             (nth 5 line)))
                 (reverse opstack)) ;lines drawn first must be at the top of the file
           (format out "</svg>")
           (close out)))))
  

(defun calc-viewbox (opstack)  
  (let* ((list-x (mapcan #' (lambda (line) ; make a list of all the x values in opstack
                              (append (list (nth 1 line))
                                      (list (nth 3 line))))
                            opstack))
         (list-y (mapcan #' (lambda (line) ; make a list of all the y values in opstack
                              (append (list (nth 2 line))
                                      (list (nth 4 line))))
                            opstack))
         (min-x (reduce #'min list-x)) ; find min x 
         (min-y (reduce #'min list-y)) ; find min y
         (max-x (reduce #'max list-x)) ; find max x
         (max-y (reduce #'max list-y))) ;find max y               
    (values (distance-on-same-axis max-x min-x) (distance-on-same-axis max-y min-y) min-x min-y))) ; width height min-x min-y

;;; returns the distance between two numbers
(defun distance-on-same-axis (c1 c2)
  (abs (- c1 c2)))

(defun draw-arrow (tr &optional o)
  (multiple-value-bind (tr o)
      (forward tr o 250)
    (multiple-value-bind (tr o)
        (left tr o 90)
      (multiple-value-bind (tr o)
          (forward tr o 100)
        (multiple-value-bind (tr o)
            (right tr o 135)
          (multiple-value-bind (tr o)
              (forward tr o 169)            
              (multiple-value-bind (tr o)
                  (right tr o 90)
                (multiple-value-bind (tr o)
                    (forward tr o 169)
                  (multiple-value-bind (tr o)
                      (left tr o 45)
                    (multiple-value-bind (tr o)
                        (back tr o 100)
                      (multiple-value-bind (tr o)
                          (left tr o 90)
                        (multiple-value-bind (tr o)
                            (back tr o 250)
                          (multiple-value-bind (tr o)
                              (right tr o 90)
                            (multiple-value-bind (tr o)
                                (back tr o 40)
                              (values tr o)))))))))))))))

(defun red-square (turtle &optional opstack)
  (multiple-value-bind (turtle opstack)
      (forward turtle opstack 100)
    (multiple-value-bind (turtle opstack)
        (right turtle opstack 90)
      (multiple-value-bind (turtle opstack)
          (forward turtle opstack 100)
        (multiple-value-bind (turtle opstack)
            (right turtle opstack 90)
          (multiple-value-bind (turtle opstack)
              (forward turtle opstack 100)
            (multiple-value-bind (turtle opstack)
                (right turtle opstack 90)
              (multiple-value-bind (turtle opstack)
                  (forward turtle opstack 100)
                (values turtle opstack))
              )))))))
