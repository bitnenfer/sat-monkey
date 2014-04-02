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

Import mojo
Import sat.vector
Import sat.base
Import sat.vecstack
Import sat.rectangle

Class Polygon Implements iSAT
	
	Private
	
	Field xMin:Float
	Field yMin:Float
	Field xMax:Float
	Field yMax:Float
	Field bounds:Rectangle
	
	Public
	
	Field position:Vector
	Field points:VecStack
	Field angle:Float
	Field offset:Vector
	Field edges:VecStack
	Field normals:VecStack
	Field calcPoints:VecStack
	
	Method New (pos:Vector = New Vector(), points:VecStack = New VecStack())
		Self.position = pos
		Self.angle = 0
		Self.points = points
		Self.offset = New Vector()
		Self.edges = New VecStack()
		Self.normals = New VecStack()
		Self.calcPoints = New VecStack()
		Self.bounds = New Rectangle(New Vector(0, 0), 0, 0);
		Self.Recalc()
	End
	
	Method Scale:Polygon (x:Float, y:Float)
		Local i:Int
		Local points:VecStack = Self.points
		Local edges:VecStack = Self.edges
		Local normals:VecStack = Self.normals
		Local len:Int = points.Length()
		
		For i = 0 To len - 1
			points.Get(i).Scale(x, y)
			edges.Get(i).Scale(x, y)
			normals.Get(i).Scale(x, y)
		Next
	End
	
	Method SetPoints:Polygon (points:VecStack)
		Self.points = points
		Self.Recalc()
		
		Return Self
	End
	
	Method SetAngle:Polygon (angle:Float)
		Self.angle = angle
		Self.Recalc()
		
		Return Self
	End
	
	Method SetOffset:Polygon (offset:Vector)
		Self.offset = offset
		Self.Recalc()
		
		Return Self
	End
	
	Method Rotate:Polygon (angle:Float)
		Local points:VecStack = Self.points
		Local len:Int = points.Length()
		Local i:Int
		
		For i = 0 To len - 1
			points.Get(i).Rotate(angle)
		Next
		Self.Recalc()
		
		Return Self
	End
	
	Method Translate:Polygon (x:Float, y:Float)
		Local points:VecStack = Self.points
		Local len:Int = points.Length()
		Local i:Int = 0
		
		For i = 0 To len - 1
			points.Get(i).x += x
			points.Get(i).y += y
		Next
		
		Self.Recalc()
		
		Return Self
	End
	
	Method Recalc:Polygon ()
		Local edges:VecStack = Self.edges.Wipe()
		Local calcPoints:VecStack = Self.calcPoints.Wipe()
		Local normals:VecStack = Self.normals.Wipe()
		Local points:VecStack = Self.points
		Local offset:Vector = Self.offset
		Local angle:Float = Self.angle
		Local len:Int = points.Length()
		Local i:Int
		For i = 0 To len - 1
			Local calcPoint:Vector = points.Get(i).Clone()
			calcPoint.x += offset.x
			calcPoint.y += offset.y
			If (angle <> 0)
				calcPoint.Rotate(angle)
			Endif
			calcPoints.Push(calcPoint)
		Next
		For i = 0 To len - 1
			Local p1:Vector = calcPoints.Get(i)
			Local p2:Vector
			If (i < len - 1)
				p2 = calcPoints.Get(i + 1)
			Else
				p2 = calcPoints.Get(0)
			Endif
			Local e:Vector = New Vector().Copy(p2).Sub(p1)
			Local n:Vector = New Vector().Copy(e).Perp().Normalize()
			edges.Push(e)
			normals.Push(n)
		Next
		Return Self
	End
	
	Method GetBounds:Rectangle ()
		Local len:Int = calcPoints.Length()
		xMin = calcPoints.Get(0).x + position.x
		yMin = calcPoints.Get(0).y + position.y
		xMax = xMin
		yMax = yMin
		Local x:Float
		Local y:Float
		Local i:Int
		
		For i = 0 To len - 1
			x = calcPoints.Get(i).x + position.x
			y = calcPoints.Get(i).y + position.y
			If (x < xMin)
				xMin = x
			Endif
			If (x > xMax)
				xMax = x
			Endif
			If (y < yMin)
				yMin = y
			Endif
			If (y > yMax)
				yMax = y
			Endif
		Next
		
		bounds.position.x = xMin
		bounds.position.y = yMin
		bounds.width = xMax - xMin
		bounds.height = yMax - yMin

		Return bounds
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
	
	Method DebugDraw:Void ()
		PushMatrix()
		mojo.Translate(position.x, position.y)
		DrawPoint(0, 0)
		Local p:Vector
		Local n:Vector
		For Local i:Int = 0 To calcPoints.Length() - 1
			If (i > 0)
				n = calcPoints.Get(i - 1)
			Else
				n = calcPoints.Get(i)
			Endif
			p = calcPoints.Get(i)
			
			DrawLine(n.x, n.y, p.x, p.y)
		Next
		If (calcPoints.Length() > 1)
			DrawLine(p.x, p.y, calcPoints.Get(0).x, calcPoints.Get(0).y)
		Endif
		PopMatrix()
	End
End