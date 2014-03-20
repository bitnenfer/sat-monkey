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
Import sat.polygon
Import sat.base

Class Box Implements iSAT
	
	Field position:Vector
	Field width:Float
	Field height:Float
	
	Method New(pos:Vector = New Vector(), width:Float = 0.0, height:Float = 0.0)
		Self.position = pos
		Self.width = width
		Self.height = height
	End
	
	Method ToPolygon:Polygon ()
		Local pos:Vector = Self.position
		Local w:Float = Self.width
		Local h:Float = Self.height
		
		Return New Polygon(New Vector(pos.x, pos.y), New VecStack([
		New Vector(), New Vector(w, 0), 
		New Vector(w, h), New Vector(0, h)]))
	End
	
	Method GetBounds:Box ()
		Return ToPolygon().GetBounds()
	End
	
	Method DebugDraw:Void ()
		Self.ToPolygon().DebugDraw()
	End
	
	Method GetPosition:Vector ()
		Return position
	End
	
	Method SetPosition:Void (x:Float, y:Float)
		position.Copy(x, y)
	End
	
	Method SetPosition:Void (vec:Vector)
		position.Copy(vec)
	End
	
	Method GetType:Int ()
		Return POLYGON
	End
End