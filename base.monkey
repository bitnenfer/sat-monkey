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

Import sat.box
Import sat.vector

Const POLYGON:Int = 0
Const CIRCLE:Int = 1
Const VECTOR:Int = 3

Interface iSAT
	Method GetBounds:Box ()
	Method DebugDraw:Void ()
	Method GetPosition:Vector ()
	Method SetPosition:Void (x:Float, y:Float)
	Method SetPosition:Void (vec:Vector)
	Method GetType:Int ()
End