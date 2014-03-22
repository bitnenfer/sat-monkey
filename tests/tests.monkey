Strict

Import sat

Function TestPolygonToPolygon:Void ()
	Print "Start Polygon to Polygon"
	Local polygon1:Polygon
	Local polygon2:Polygon
	Local response:Response
	response = New Response()
	polygon1 = New Polygon(New Vector(0, 0), New VecStack([
	New Vector(0, 0), New Vector(40, 0), New Vector(40, 40), New Vector(0, 40)]))
	
	polygon2 = New Polygon(New Vector(30, 0), New VecStack([
	New Vector(0, 0), New Vector(30, 0), New Vector(0, 30)]))
	
	Local collide:Bool = SAT.TestPolygonPolygon(polygon1, polygon2, response)
	
	Print "SHOULD: ~ncollided => true~n" +
	"response.overlap => 10~n" +
	"response.overlapV => (10, 0)~n"
	
	Print "GET:"
	If collide
		Print "collide => true"
	Else 
		Print "collide => false"
	Endif
	
	Print "response.overlap => " + response.overlap
	Print "response.overlapV => " + response.overlapV.x + ", " + response.overlapV.y
	Print "End Polygon to Polygon~n----------~n~n"
End

Function TestPolygonToCircle:Void ()
	Print "Start Polygon to Circle"
	Local circle:Circle
	Local polygon:Polygon
	Local response:Response
	response = New Response()
	circle = New Circle(New Vector(50, 50), 20)
	
	polygon = New Polygon(New Vector(0, 0), New VecStack([
	New Vector(0, 0), New Vector(40, 0), New Vector(40, 40), New Vector(0, 40)]))
	
	Local collide:Bool = SAT.TestPolygonCircle(polygon, circle, response)
	
	Print "SHOULD: ~ncollided => true~n" +
	"response.overlap => 5.86~n" +
	"response.overlapV => (4.14, 4.14) - i.e. on a diagonal~n"
	
	Print "GET:"
	If collide
		Print "collide => true"
	Else 
		Print "collide => false"
	Endif
	
	Print "response.overlap => " + response.overlap
	Print "response.overlapV => " + response.overlapV.x + ", " + response.overlapV.y
	Print "End Polygon to Circle~n----------~n~n"
End

Function NoCollisionBoxes:Void ()
	Print "No collision between two boxes"
	Local box1:Polygon
	Local box2:Polygon
	Local response:Response
	response = New Response()
	box1 = New Box(New Vector(0, 0), 20, 20).ToPolygon()
	box2 = New Box(New Vector(100, 100), 20, 20).ToPolygon()
	
	Local collide:Bool = SAT.TestPolygonPolygon(box1, box2, response)
	
	Print "SHOULD: ~ncollided => false~n"
	
	Print "GET:"
	If collide
		Print "collide => true"
	Else 
		Print "collide => false"
	Endif
	
	Print "End No collision between two boxes~n----------~n~n"
End

Function HitTestCircleAndPolygon:Void ()
	Print "Hit testing a circle and polygon"
	Local triangle:Polygon
	Local circle:Circle
	triangle = New Polygon(New Vector(30, 0), New VecStack([
	New Vector(), New Vector(30, 0), New Vector(0, 30)]))
	circle = New Circle(New Vector(100, 100), 20)
	
	
	Print "SHOULD: ~nfalse~ntrue~nfalse~ntrue~n"
	
	Print "GET:"
	If (SAT.PointInPolygon(New Vector(0, 0), triangle))
		Print "true"
	Else
		Print "false"
	Endif
	
	If (SAT.PointInPolygon(New Vector(35, 5), triangle))
		Print "true"
	Else
		Print "false"
	Endif
	
	If (SAT.PointInCircle(New Vector(0, 0), circle))
		Print "true"
	Else
		Print "false"
	Endif
	
	If (SAT.PointInCircle(New Vector(110, 110), circle))
		Print "true"
	Else
		Print "false"
	EndIf
	
	Print "End Hit testing a circle and polygon~n----------~n~n"
End



Function Main:Int ()
	TestPolygonToPolygon()
	TestPolygonToCircle()
	NoCollisionBoxes()
	HitTestCircleAndPolygon()
	Return 0
End