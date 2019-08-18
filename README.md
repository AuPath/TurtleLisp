# TurtleLisp
Toy project where the user is able to draw pictures saved in svg format by operating a "Turtle" via the following functions.

Every function here described checks if the "turtle" and "opstack" passed are valid.
Every function fails if "turtle" or "opstack" is invalid. 
"opstack" is valid only if each line that it contains is valid.

**1)** 	Function : pencolor
	arg : turtle
	arg : opstack
	arg : color (as keyword)
	
	Example : (pencolor '(:turtle 0 0 0 :black T) nil ':red)
			   => (:turtle 0 0 0 :red T) nil
			   
	Changes the turtle's color with the color supplied as argument.
	Valid colors are :black :white :red :cyan :purple :green :blue :yellow
	Returns a new turtle whith the new color and an unchanged opstack.
	If the supplied color is not valid return nil.
	
**2)**	Function : pendown
	arg : turtle
	arg : opstack
	
	Example : (pendown '(:turtle 0 0 0 :black F) nil)
				=> (:turtle 0 0 0 :black T) nil
				
	Changes the pen position to T(true).
	Only when the pen is true does the turtle draw lines.
	Returns the new "turtle" and an unchanged "opstack".
	
**3)**	Function : penup
	arg : turtle
	arg : opstack
	
	Example : (pendown '(:turtle 0 0 0 :black T) nil)
				=> (:turtle 0 0 0 :black F) nil
				
	Changes the pen position to nil(false).
	Returns the new "turtle" and an unchanged "opstack".
	
**4)**	Function : setx
	arg : turtle
	arg : opstack
	arg : x (must be integer)
	
	Example : (setx '(:turtle 0 0 0 :black T) nil 100)
				=> (:turtle 100 0 0 :black T) nil
				
	Changes the turtle's x coordinate.
	Does not draw lines.
	Returns the new "turtle" and an unchanged "opstack".

**5)**	Function : sety
	arg : turtle
	arg : opstack
	arg : y (must be integer)
	
	Example : (sety '(:turtle 0 0 0 :black T) nil 100)
				=> (:turtle 0 100 0 :black T) nil
				
	Changes the turtle's y coordinate.
	Does not draw lines.
	Returns the new "turtle" and an unchanged "opstack".
	
**6)**	Function : setheading
	arg : turtle
	arg : opstack
	arg : degrees (0 <= degrees < 360)
	
	Example : (setheading '(:turtle 0 0 0 :black T) nil 45)
				=> (:turtle 0 0 45 :black T) nil
				
	Changes the turtle's orientation.
	Does not draw lines.
	Returns the new "turtle" and an unchanged "opstack".
	
**7)**	Function : left
	arg : turtle
	arg : opstack
	arg : degrees (degrees >= 0)
	
	Example : (left '(:turtle 0 0 0 :black T) nil 45)
				=> (:turtle 0 0 315 :black T) nil
			  (left '(:turtle 0 0 0 :black T) nil 362)
				=> (:turtle 0 0 358 :black T) nil
				
	Changes the turtle's orientation by subtracting degress from the current orientation.
	Does not draw lines.
	Returns the new "turtle" and an unchanged "opstack".
	
**8)**	Function : right
	arg : turtle	
	arg : opstack	
	arg : degrees (degrees >= 0)
	
	Example : (right '(:turtle 0 0 0 :black T) nil 45)
				=> (:turtle 0 0 45 :black T) nil
			  (right '(:turtle 0 0 0 :black T) nil 362)
				=> (:turtle 0 0 2 :black T) nil
				
	Changes the turtle's orientation by adding degress to the current orientation.
	Does not draw lines.
	Returns the new "turtle" and an unchanged "opstack".
	
**9)**	Function : forward
	arg : turtle
	arg : opstack
	arg : distance (distance >= 0)
	
	Example : (forward '(:turtle 0 0 0 :black T) nil 100)
				=> (:turtle 0 -100 0 :black T) ((:line 0 0 0 -100 :black))

	Changes the turtle's position by moving forward by "distance" units.
	Draws a line and adds it to the top of the opstack if the pen is down(T).
	The line is drawn from the previous position to the one after moving.
	
**10)**	Function : back
	arg : turtle
	arg : opstack
	arg : distance (distance >= 0)
	
	Example : (back '(:turtle 0 0 0 :black T) nil 100)
				=> (:turtle 0 100 0 :black T) ((:line 0 0 0 100 :black))

	Changes the turtle's position by moving backwards by "distance" units.
	Draws a line and adds it to the top of the opstack if the pen is down(T).
	The line is drawn from the previous position to the one after moving.
	
**11)**	Function : home
	arg : turtle
	arg : opstack	
	
	Example : (home '(:turtle 42 626 0 :black T) nil)
				=> (:turtle 0 0 0 :black T) ((:line 42 626 0 0 :black))

	Changes the turtle's position to the origin (0,0).
	Draws a line and adds it to the top of the opstack if the pen is down(T).
	The line is drawn from the previous position to the one after moving.
	
**12)**	Function : dump-svg
	arg : filename	(string)
	arg : opstack	(not nil)
	
	Example : (dump-svg "LispFile" '((:LINE 42 626 0 0 :BLACK)))
				=> T
	
	Returns T if the file was successfully created.
	If a file named "filename" already exists it is overwritten.
	Returns nil if the opstack is empty, even if technically an empty opstack is valid.
	The file is created as a side effect.
	
## PS:
Se stai guardando questo progetto con l'intento di copiare evita perchè sicuro ti beccano.
