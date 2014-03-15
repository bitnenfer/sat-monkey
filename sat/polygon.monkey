Strict

Import mojo
Import sat.vector
Import sat.base
Import sat.vecstack

Class Polygon Implements iBase
	
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
		Local i:Int
		Local points:VecStack = Self.points
		Local edges:VecStack = Self.edges
		Local normals:VecStack = Self.normals
		Local len:Int = points.Length()
		Local cos:Float = Cos(angle)
		Local sin:Float = Sin(angle)
		
		For i = 0 To len - 1
			points.Get(i).RotatePrecalc(sin, cos)
			edges.Get(i).RotatePrecalc(sin, cos)
			normals.Get(i).RotatePrecalc(sin, cos)
		Next
		
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
			Self.calcPoints.Push(calcPoint)
		Next
		For i = 0 To len - 1
			Local p1:Vector = Self.calcPoints.Get(i)
			Local p2:Vector
			If (i < len - 1)
				p2 = Self.calcPoints.Get(i + 1)
			Else
				p2 = Self.calcPoints.Get(0)
			Endif
			Local e:Vector = New Vector().Copy(p2).Sub(p1)
			Local n:Vector = New Vector().Copy(e).Perp().Normalize()
			Self.edges.Push(e)
			Self.normals.Push(n)
		Next
		Return Self
	End
	
	Method DebugDraw:Void ()
		PushMatrix()
		mojo.Translate(position.x, position.y)
		DrawCircle(0, 0, 4)
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