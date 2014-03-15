Strict

Import mojo
Import sat

Class Test1 Extends App
	Field circle1:Circle
	Field circle2:Circle
	Field response:Response
	Method OnCreate:Int()
		circle1 = New Circle(New Vector(160, 120), 30)
		circle2 = New Circle(New Vector(30, 30), 10)
		response = New Response()
		SetUpdateRate(60)
		Return 0
	End
	
	Method OnUpdate:Int()
		circle1.position.Copy(MouseX(), MouseY())
		If (SAT.TestCircleCircle(circle1, circle2, response))
			circle2.position.Add(response.overlapV)
		Endif
		Return 0
	End
	
	Method OnRender:Int()
		Cls()
		circle1.DebugDraw()
		circle2.DebugDraw()
		Return 0
	End
End

Class Test2 Extends App
	Field circle:Circle
	Field polygon:Polygon
	Field response:Response
	Field angle:Float = 0
	Method OnCreate:Int()
		polygon = New Polygon(New Vector(160, 120), New VecStack([
			New Vector(0,0), New Vector(60, 0), New Vector(100, 40), New Vector(60, 80), New Vector(0, 80)]))
		circle = New Circle(New Vector(300, 300), 20)
		response = New Response()
		SetUpdateRate(60)
		Return 0
	End
	
	Method OnUpdate:Int()
		If (MouseX() <> 0 And MouseY() <> 0)
			circle.position.x = MouseX() 
			circle.position.y = MouseY()
		Endif
		
		If (KeyDown(KEY_D))
			circle.position.x += 2
		Elseif (KeyDown(KEY_A))
			circle.position.x -= 2
		Endif
		
		If (KeyDown(KEY_S))
			circle.position.y += 2
		Elseif (KeyDown(KEY_W))
			circle.position.y -= 2
		Endif
		angle += 0.1
		
		polygon.SetAngle(angle)
		
		Return 0
	End
	
	Method OnRender:Int()
		Cls()
		If (SAT.TestPolygonCircle(polygon, circle, response))
			polygon.position.Sub(response.overlapV)
		Endif
		response.Clear()
		circle.DebugDraw()
		polygon.DebugDraw()
		
		Return 0
	End
End

Class Test3 Extends App
	Field polygon1:Polygon
	Field polygon2:Polygon
	Field response:Response
	Method OnCreate:Int()
		polygon1 = New Polygon(New Vector(160, 120), New VecStack([
			New Vector(0,0), New Vector(60, 0), New Vector(100, 40), New Vector(60, 80), New Vector(0, 80)]))
		polygon2 = New Polygon(New Vector(10, 10), New VecStack([
			New Vector(0, 0), New Vector(30, 0), New Vector(30, 30), New Vector(0, 30)]))
		response = New Response()
		SetUpdateRate(60)
		Return 0
	End
	
	Method OnUpdate:Int()
		If (MouseX() <> 0 And MouseY() <> 0)
			polygon2.position.x = MouseX() 
			polygon2.position.y = MouseY()
		Endif
		
		Return 0
	End
	
	Method OnRender:Int()
		Cls()
		If (SAT.TestPolygonPolygon(polygon2, polygon1, response))
			polygon1.position.Add(response.overlapV)
		Endif
		response.Clear()
		polygon1.DebugDraw()
		polygon2.DebugDraw()
		Return 0
	End
End

Function Main:Int ()
	New Test2()
	Return 0
End