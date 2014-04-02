Strict

Import mojo
Import sat

Class CircleToCircle Extends App
	Field circle1:Circle
	Field circle2:Circle
	Field response:Response
	Method OnCreate:Int()
		circle1 = New Circle(New Vec2(160, 120), 30)
		circle2 = New Circle(New Vec2(30, 30), 10)
		response = New Response()
		SetUpdateRate(60)
		Return 0
	End
	
	Method OnUpdate:Int()
		circle1.position.Copy(MouseX(), MouseY())
		If (SAT.TestCircleCircle(circle1, circle2, response))
			circle2.position.Add(response.overlapV)
		Endif
		response.Clear()
		Return 0
	End
	
	Method OnRender:Int()
		Cls()
		circle1.DebugDraw()
		circle2.DebugDraw()
		Return 0
	End
End

Function Main:Int ()
	New CircleToCircle()
	Return 0
End