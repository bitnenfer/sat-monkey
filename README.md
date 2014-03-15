#SAT (Separating Axis Theorem) for Monkey

This is a port of [SAT.js](https://github.com/jriecken/sat-js/) to [Monkey-X](http://monkey-x.com/).

The original version was created by [Jim Riecken](http://www.jimr.ca/) in JavaScript and ported to Monkey by [Felipe Alfonso](http://shin.cl/).

This port is based on version 0.4.

[More information on SAT](http://en.wikipedia.org/wiki/Hyperplane_separation_theorem)

Examples
---

###Circle to Circle Test

[Result](http://dev.shin.cl/sat-monkey/circletocircle/)

```
Strict

Import mojo
Import sat

Class CircleToCircle Extends App
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
```

###Circle to Polygon Test

[Result](http://dev.shin.cl/sat-monkey/circletopolygon/)

```
Strict

Import mojo
Import sat

Class CircleToPolygon Extends App
	Field circle:Circle
	Field polygon:Polygon
	Field response:Response
	Method OnCreate:Int()
		polygon = New Polygon(New Vector(160, 120), New VecStack([
			New Vector(0,0), New Vector(60, 0), New Vector(100, 40), New Vector(60, 80), New Vector(0, 80)]))
		circle = New Circle(New Vector(300, 300), 20)
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
```

###Polygon to Polygon Test

[Result](http://dev.shin.cl/sat-monkey/polygontopolygon/)

```
Strict

Import mojo
Import sat

Class PolygonToPolygon Extends App
	Field polygon1:Polygon
	Field polygon2:Polygon
	Field response:Response
	Method OnCreate:Int()
		polygon1 = New Polygon(New Vector(160, 120), New VecStack([
			New Vector(0,0), New Vector(60, 0), New Vector(100, 40), New Vector(60, 80), New Vector(0, 80)]))
		polygon2 = New Polygon(New Vector(10, 10), New VecStack([
			New Vector(0, 0), New Vector(30, 0), New Vector(30, 30), New Vector(0, 30)]))
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
```