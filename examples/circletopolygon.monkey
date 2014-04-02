Strict

Import mojo
Import sat

Class CircleToPolygon Extends App
	Field circle:Circle
	Field polygon:Polygon
	Field response:Response
	Method OnCreate:Int()
		polygon = New Polygon(New Vector2(160, 120), New VecStack([
			New Vector2(0,0), New Vector2(60, 0), New Vector2(100, 40), New Vector2(60, 80), New Vector2(0, 80)]))
		circle = New Circle(New Vector2(300, 300), 20)
		response = New Response()
		polygon.Translate(-30, -40)
		SetUpdateRate(60)
		Return 0
	End
	
	Method OnUpdate:Int()
		circle.position.Copy(MouseX(), MouseY())
		polygon.Rotate(1)
		If (SAT.TestCirclePolygon(circle, polygon, response))
			polygon.position.Add(response.overlapV)
		Endif
		response.Clear()
		Return 0
	End
	
	Method OnRender:Int()
		Cls()
		circle.DebugDraw()
		polygon.DebugDraw()
		Return 0
	End
End

Function Main:Int ()
	New CircleToPolygon()
	Return 0
End