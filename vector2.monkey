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

Class Vector2 Implements iSAT

	Field x:Float
	Field y:Float
	
	Method New (x:Float = 0, y:Float = 0)
		Self.x = x
		Self.y = y
	End
	
	Method Copy:Vector2 (other:Vector2)
		Self.x = other.x
		Self.y = other.y
		
		Return Self
	End
	
	Method Copy:Vector2 (x:Float, y:Float)
		Self.x = x
		Self.y = y
		
		Return Self
	End
	
	Method Clone:Vector2 ()
		Return New Vector2(Self.x, Self.y)
	End
	
	Method Perp:Vector2 ()
		Local x:Float = Self.x
		
		Self.x = Self.y
		Self.y = -x
		
		Return Self
	End
	
	Method Rotate:Vector2 (angle:Float)
		Local x:Float = Self.x
		Local y:Float = Self.y
		
		Self.x = x * Cos(angle) - y * Sin(angle)
		Self.y = x * Sin(angle) + y * Cos(angle)
		
		Return Self
	End
	
	Method RotatePrecalc:Vector2 (sin:Float, cos:Float)
		Local x:Float = Self.x 
		Local y:Float = Self.y
		
		Self.x = x * cos - y * sin
		Self.y = x * sin + y * cos
		
		Return Self
	End
	
	Method Reverse:Vector2 ()
		Self.x = -Self.x
		Self.y = -Self.y
		
		Return Self
	End
	
	Method Normalize:Vector2 ()
		Local d:Float = Self.Length()
		
		If (d > 0)
			Self.x = Self.x / d
			Self.y = Self.y / d
		Endif
		
		Return Self
	End
	
	Method Add:Vector2 (other:Vector2)
		Self.x += other.x
		Self.y += other.y
		
		Return Self
	End
	
	Method Sub:Vector2 (other:Vector2)
		Self.x -= other.x
		Self.y -= other.y
		
		Return Self
	End
	
	Method Multiply:Vector2 (other:Vector2)
		Self.x *= other.x
		Self.y *= other.y
		
		Return Self
	End
	
	Method Scale:Vector2 (value:Float)
		Self.x *= value
		Self.y *= value
		
		Return Self
	End
	
	Method Scale:Vector2 (x:Float, y:Float)
		Self.x *= x
		Self.y *= y
		
		Return Self
	End
	
	Method Project:Vector2 (other:Vector2)
		Local amt:Float = Self.Dot(other) / other.Length2()
		
		Self.x = amt * other.x
		Self.y = amt * other.y
		
		Return Self
	End
	
	Method ProjectN:Vector2 (other:Vector2)
		Local amt:Float = Self.Dot(other)
		
		Self.x = amt * other.x
		Self.y = amt * other.y
		
		Return Self
	End
	
	Method Reflect:Vector2 (axis:Vector2)
		Local x:Float = Self.x
		Local y:Float = Self.y
		
		Self.Project(axis).Scale(2)
		Self.x -= x
		Self.y -= y
		
		Return Self
	End
	
	Method ReflectN:Vector2 (axis:Vector2)
		Local x:Float = Self.x
		Local y:Float = Self.y
		
		Self.ProjectN(axis).Scale(2)
		Self.x -= x
		Self.y -= y
		
		Return Self
	End
	
	Method Dot:Float (other:Vector2)
		Return Self.x * other.x + Self.y * other.y
	End
	
	Method Length2:Float ()
		Return Self.Dot(Self)
	End
	
	Method Length:Float ()
		Return Sqrt(Self.Length2())
	End
	
	Method GetBounds:Rectangle ()
		Return New Rectangle(New Vector2(x, y), 1, 1)
	End
	
	Method GetPosition:Vector2 ()
		Return Self
	End
	
	Method SetPosition:Void (x:Float, y:Float)
		Self.Copy(x, y)
	End
	
	Method SetPosition:Void (vec:Vector2)
		Self.Copy(vec)
	End
	
	Method GetType:Int ()
		Return VECTOR
	End
	
	Method DebugDraw:Void ()
		DrawPoint(x, y)
	End
End