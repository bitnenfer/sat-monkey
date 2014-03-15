#REM
	Version 0.4 - Copyright 2014 -  Jim Riecken <jimr@jimr.ca>
	Released under the MIT License - https://github.com/jriecken/sat-js
	A simple library for determining intersections of circles and
	polygons using the Separating Axis Theorem.
	@preserve SAT.js - Version 0.4 - Copyright 2014 - Jim Riecken <jimr@jimr.ca> - 
	released under the MIT License. https://github.com/jriecken/sat-js
	
	Ported to Monkey by Felipe Alfonso
	https://github.com/ilovepixel/
#END

Strict

Import sat.base

Class Vector Implements iBase

	Field x:Float
	Field y:Float
	
	Method New (x:Float = 0, y:Float = 0)
		Self.x = x
		Self.y = y
	End
	
	Method Copy:Vector (other:Vector)
		Self.x = other.x
		Self.y = other.y
		
		Return Self
	End
	
	Method Copy:Vector (x:Float, y:Float)
		Self.x = x
		Self.y = y
		
		Return Self
	End
	
	Method Clone:Vector ()
		Return New Vector(Self.x, Self.y)
	End
	
	Method Perp:Vector ()
		Local x:Float = Self.x
		
		Self.x = Self.y
		Self.y = -x
		#REM
		var x = this['x'];
    this['x'] = this['y'];
    this['y'] = -x;
    return this;
		#END
		Return Self
	End
	
	Method Rotate:Vector (angle:Float)
		Local x:Float = Self.x
		Local y:Float = Self.y
		
		Self.x = x * Cos(angle) - y * Sin(angle)
		Self.y = x * Sin(angle) + y * Cos(angle)
		
		Return Self
	End
	
	Method RotatePrecalc:Vector (sin:Float, cos:Float)
		Local x:Float = Self.x 
		Local y:Float = Self.y
		
		Self.x = x * cos - y * sin
		Self.y = x * sin + y * cos
		
		Return Self
	End
	
	Method Reverse:Vector ()
		Self.x = -Self.x
		Self.y = -Self.y
		
		Return Self
	End
	
	Method Normalize:Vector ()
		Local d:Float = Self.Length()
		
		If (d > 0)
			Self.x = Self.x / d
			Self.y = Self.y / d
		Endif
		
		Return Self
	End
	
	Method Add:Vector (other:Vector)
		Self.x += other.x
		Self.y += other.y
		
		Return Self
	End
	
	Method Sub:Vector (other:Vector)
		Self.x -= other.x
		Self.y -= other.y
		
		Return Self
	End
	
	Method Multiply:Vector (other:Vector)
		Self.x *= other.x
		Self.y *= other.y
		
		Return Self
	End
	
	Method Scale:Vector (value:Float)
		Self.x *= value
		Self.y *= value
		
		Return Self
	End
	
	Method Scale:Vector (x:Float, y:Float)
		Self.x *= x
		Self.y *= y
		
		Return Self
	End
	
	Method Project:Vector (other:Vector)
		Local amt:Float = Self.Dot(other) / other.Length2()
		
		Self.x = amt * other.x
		Self.y = amt * other.y
		
		Return Self
	End
	
	Method ProjectN:Vector (other:Vector)
		Local amt:Float = Self.Dot(other)
		
		Self.x = amt * other.x
		Self.y = amt * other.y
		
		Return Self
	End
	
	Method Reflect:Vector (axis:Vector)
		Local x:Float = Self.x
		Local y:Float = Self.y
		
		Self.Project(axis).Scale(2)
		Self.x -= x
		Self.y -= y
		
		Return Self
	End
	
	Method ReflectN:Vector (axis:Vector)
		Local x:Float = Self.x
		Local y:Float = Self.y
		
		Self.ProjectN(axis).Scale(2)
		Self.x -= x
		Self.y -= y
		
		Return Self
	End
	
	Method Dot:Float (other:Vector)
		Return Self.x * other.x + Self.y * other.y
	End
	
	Method Length2:Float ()
		Return Self.Dot(Self)
	End
	
	Method Length:Float ()
		Return Sqrt(Self.Length2())
	End
	
End