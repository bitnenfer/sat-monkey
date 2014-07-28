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

Import sat.base

Class Vec2 Implements iSAT

	Field x:Float
	Field y:Float
	
	Method New (x:Float = 0, y:Float = 0)
		Self.x = x
		Self.y = y
	End
	
	Method Empty:Bool ()
		Return Self.x = 0 And Self.y = 0
	End
	
	Method Copy:Vec2 (other:Vec2)
		Self.x = other.x
		Self.y = other.y
		
		Return Self
	End
	
	Method Set:Vec2(x:Float, y:Float)
		Self.x = x
		Self.y = y
		
		Return Self
	End
	
	Method Clone:Vec2 ()
		Return New Vec2(Self.x, Self.y)
	End
	
	Method Perp:Vec2 ()
		Local x:Float = Self.x
		
		Self.x = Self.y
		Self.y = -x
		
		Return Self
	End
	
	Method Rotate:Vec2 (angle:Float)
		Local x:Float = Self.x
		Local y:Float = Self.y
		
		Self.x = x * Cos(angle) - y * Sin(angle)
		Self.y = x * Sin(angle) + y * Cos(angle)
		
		Return Self
	End
	
	Method RotatePrecalc:Vec2 (sin:Float, cos:Float)
		Local x:Float = Self.x 
		Local y:Float = Self.y
		
		Self.x = x * cos - y * sin
		Self.y = x * sin + y * cos
		
		Return Self
	End
	
	Method Reverse:Vec2 ()
		Self.x = -Self.x
		Self.y = -Self.y
		
		Return Self
	End
	
	Method Normalize:Vec2 ()
		Local d:Float = Self.Length()
		
		If (d > 0)
			Self.x = Self.x / d
			Self.y = Self.y / d
		Endif
		
		Return Self
	End
	
	Method Add:Vec2 (other:Vec2)
		Self.x += other.x
		Self.y += other.y
		
		Return Self
	End
	
	Method Sub:Vec2 (other:Vec2)
		Self.x -= other.x
		Self.y -= other.y
		
		Return Self
	End
	
	Method Multiply:Vec2 (other:Vec2)
		Self.x *= other.x
		Self.y *= other.y
		
		Return Self
	End
	
	Method Scale:Vec2 (value:Float)
		Self.x *= value
		Self.y *= value
		
		Return Self
	End
	
	Method Scale:Vec2 (x:Float, y:Float)
		Self.x *= x
		Self.y *= y
		
		Return Self
	End
	
	Method Project:Vec2 (other:Vec2)
		Local amt:Float = Self.Dot(other) / other.Length2()
		
		Self.x = amt * other.x
		Self.y = amt * other.y
		
		Return Self
	End
	
	Method ProjectN:Vec2 (other:Vec2)
		Local amt:Float = Self.Dot(other)
		
		Self.x = amt * other.x
		Self.y = amt * other.y
		
		Return Self
	End
	
	Method Reflect:Vec2 (axis:Vec2)
		Local x:Float = Self.x
		Local y:Float = Self.y
		
		Self.Project(axis).Scale(2)
		Self.x -= x
		Self.y -= y
		
		Return Self
	End
	
	Method ReflectN:Vec2 (axis:Vec2)
		Local x:Float = Self.x
		Local y:Float = Self.y
		
		Self.ProjectN(axis).Scale(2)
		Self.x -= x
		Self.y -= y
		
		Return Self
	End
	
	Method Dot:Float (other:Vec2)
		Return Self.x * other.x + Self.y * other.y
	End
	
	Method Length2:Float ()
		Return Self.Dot(Self)
	End
	
	Method Length:Float ()
		Return Sqrt(Self.Length2())
	End
	
	Method GetBounds:Rectangle ()
		Return New Rectangle(x, y, 1, 1)
	End
	
	Method GetPosition:Vec2 ()
		Return Self
	End
	
	Method SetPosition:Void (x:Float, y:Float)
		Self.Copy(x, y)
	End
	
	Method SetPosition:Void (vec:Vec2)
		Self.Copy(vec)
	End
	
	Method GetType:Int ()
		Return ShapeType.VECTOR
	End
	
	Method DebugDraw:Void ()
		DrawPoint(x, y)
	End
End