#REM
	Version 0.4 - Copyright 2014 -  Jim Riecken <jimr@jimr.ca>
	Released under the MIT License - https://github.com/jriecken/sat-js
	A simple library for determining intersections of circles and
	polygons using the Separating Axis Theorem.
	@preserve SAT.js - Version 0.4 - Copyright 2014 - Jim Riecken <jimr@jimr.ca> - 
	released under the MIT License. https://github.com/jriecken/sat-js
	
	Ported to Monkey by Felipe Alfonso <contact@shin.cl> -
	https://github.com/ilovepixel/sat-monkey/
#END

Strict

Import sat.vector
Import sat.sat
Import sat.base

Class Response
	
	Field a:iBase = Null
	Field b:iBase = Null
	Field overlapN:Vector
	Field overlapV:Vector
	Field aInB:Bool
	Field bInA:Bool
	Field overlap:Float
	
	Method New ()
		overlapN = New Vector()
		overlapV = New Vector()
		Self.Clear()
	End
	
	Method Clear:Response ()
		Self.aInB = True
		Self.bInA = True
		Self.overlap = SAT.MAX_VALUE
		
		Return Self
	End
End