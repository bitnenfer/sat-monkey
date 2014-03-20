#SAT (Separating Axis Theorem) for Monkey

This is a port of [SAT.js](https://github.com/jriecken/sat-js/) to [Monkey-X](http://monkey-x.com/).

The original version was created by [Jim Riecken](http://www.jimr.ca/) in JavaScript and ported to Monkey by [Felipe Alfonso](http://shin.cl/).

This port is based on version 0.4.

[More information on SAT](http://en.wikipedia.org/wiki/Hyperplane_separation_theorem)

[Small Demo](http://dev.shin.cl/sat-monkey/demo/)

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

###QuadTree Test

[Result](http://dev.shin.cl/sat-monkey/quadtree/compare/)

```
Strict

Import mojo
Import sat

Class Game Extends App

	Field fps:FPS
	Field quadTree:QuadTree
	Field pool:Stack<Polygon>
	Field response:Response
	Field useQuad:Bool = True
	Field returnObjects:Stack<iSAT>
	Field poly1:Polygon
	
	Method OnCreate:Int ()
		poly1 = New Polygon(New Vector(0, 0), New VecStack([
			New Vector(0,0), New Vector(60, 0), New Vector(100, 40), New Vector(60, 80), New Vector(0, 80)]))
			
		poly1.Translate(-poly1.GetBounds().width / 2, -poly1.GetBounds().height / 2)
		pool = New Stack<Polygon>()
		pool.Push(poly1)
		quadTree = New QuadTree(0, 0, DeviceWidth(), DeviceHeight())
		response = New Response()
		For Local i:Int = 0 To 300
			Local p:Polygon = New Polygon(New Vector(Rnd(100, DeviceWidth()-100), Rnd(100, DeviceHeight-100)), 
					New VecStack([New Vector(0, 0), New Vector(10, 0), New Vector(10, 10), New Vector(0, 10)]))
			p.Translate(-5, -5)
			pool.Push(p)
		Next
		fps = New FPS()
		SetUpdateRate(60)
		Return 0
	End
	
	Method OnUpdate:Int ()
		poly1.position.Copy(MouseX(), MouseY())
		poly1.Rotate(3)
		If (KeyHit(KEY_SPACE))
			useQuad = (Not useQuad = True)
		Endif
		Return 0
	End
	
	Method OnRender:Int ()
		Cls()

		Local o:Polygon
		Local p:Polygon
		
		If (useQuad) 
			quadTree.Clear()
		Endif
		
		o = pool.Get(0)
		
		If (useQuad)	
			Local t:Polygon
			For Local i:Int = 0 To pool.Length() - 1
				t = pool.Get(i)
				If (useQuad)
					quadTree.Insert(t)
				EndIf
				returnObjects = quadTree.Retrieve(t)
				For Local j:Int = 0 To returnObjects.Length() - 1
					p = Polygon(returnObjects.Get(j))
					If (t <> p And SAT.TestPolygonPolygon(t, p, response))
						If (p <> poly1) p.position.Add(response.overlapV)
						If (t <> poly1) t.position.Sub(response.overlapV)
					Endif
					response.Clear()
				Next
				
				t.DebugDraw()
				response.Clear()
			Next
			
			DrawText("Using QuadTree", 0, 0)
		Else
			Local t:Polygon
			For Local i:Int = 0 To pool.Length() - 1
				t = pool.Get(i)
				For Local j:Int = 0 To pool.Length() - 1
					p = pool.Get(j)
					If (t <> p And SAT.TestPolygonPolygon(t, p, response))
						If (p <> poly1) p.position.Add(response.overlapV)
						If (t <> poly1) t.position.Sub(response.overlapV)
					Endif
					response.Clear()
				Next
				t.DebugDraw()
				response.Clear()
			Next
			
			DrawText("NO QuadTree", 0, 0)
		Endif
		
		For Local i:Int = 0 To pool.Length() - 1
			o = pool.Get(i)
			If (o <> poly1) o.Rotate(-1)
		Next
		
		If (useQuad)
			SetAlpha(0.2)
			quadTree.DebugDraw()
			SetAlpha(1.0)
		Endif
		fps.UpdateFPS()
		DrawText("Press Space to turn on/off quad trees", DeviceWidth() / 2, DeviceHeight(), 0.5, 1)
		Return 0
	End
End

Class FPS
	Field startTime:Float
	Field framesNumber:Float
	Method New()
		framesNumber = 0
		startTime = Millisecs()
	End

	Method UpdateFPS:Void()
		Local currentTime:Float = (Millisecs() - startTime)/1000

		framesNumber+=1
		SetColor(255,255,255)
		SetAlpha 1
		DrawText "FPS: " + Floor( (Floor( (framesNumber / currentTime) * 10.0) / 10.0)), DeviceWidth() / 2, 0, 0.5
		If currentTime>1
			DrawText "FPS: " + Floor( (Floor( (framesNumber / currentTime) * 10.0) / 10.0)), DeviceWidth() / 2, 0, .5
			startTime = Millisecs()
			framesNumber = 0
		Endif
	End
End


Function Main:Int ()
	New Game()
	Return 0
End
```