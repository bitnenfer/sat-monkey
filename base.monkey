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

Import sat.rectangle
Import sat.vec2

Const POLYGON:Int = 0
Const CIRCLE:Int = 1
Const VECTOR:Int = 3

Interface iSAT
	Method GetBounds:Rectangle ()
	Method DebugDraw:Void ()
	Method GetPosition:Vec2 ()
	Method SetPosition:Void (x:Float, y:Float)
	Method SetPosition:Void (vec:Vec2)
	Method GetType:Int ()
End