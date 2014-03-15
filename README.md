#SAT (Separating Axis Theorem) for Monkey

This is a port of [SAT.js](https://github.com/jriecken/sat-js/) to [Monkey-X](http://monkey-x.com/).

The original version was created by [Jim Riecken](http://www.jimr.ca/) in JavaScript and ported to Monkey by [Felipe Alfonso](http://shin.cl/).

This port is based on version 0.4.

[More information on SAT](http://en.wikipedia.org/wiki/Hyperplane_separation_theorem)

###Examples

Circle to Circle Test
---

[Link](http://dev.shin.cl/sat-monkey/circletocircle/)

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