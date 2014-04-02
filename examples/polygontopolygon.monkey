Strict

Import mojo
Import sat

Class PolygonToPolygon Extends App
	Field polygon1:Polygon
	Field polygon2:Polygon
	Field response:Response
	Method OnCreate:Int()
		polygon1 = New Polygon(New Vector2(160, 120), New VecStack([
			New Vector2(0,0), New Vector2(60, 0), New Vector2(100, 40), New Vector2(60, 80), New Vector2(0, 80)]))
		polygon2 = New Polygon(New Vector2(10, 10), New VecStack([
			New Vector2(0, 0), New Vector2(30, 0), New Vector2(30, 30), New Vector2(0, 30)]))
		response = New Response()
		polygon2.Translate(-15, -15)
		SetUpdateRate(60)
		Return 0
	End
	
	Method OnUpdate:Int()
		polygon2.position.Copy(MouseX(), MouseY())
		If (SAT.TestPolygonPolygon(polygon2, polygon1, response))
			polygon1.position.Add(response.overlapV)
		Endif
		polygon2.Rotate(1)
		response.Clear()
		Return 0
	End
	
	Method OnRender:Int()
		Cls()
		polygon1.DebugDraw()
		polygon2.DebugDraw()
		Return 0
	End
End

Function Main:Int ()
	New PolygonToPolygon()
	Return 0
End