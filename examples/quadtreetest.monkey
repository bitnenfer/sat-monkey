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
		poly1 = New Polygon(New Vec2(0, 0), New VecStack([
			New Vec2(0,0), New Vec2(60, 0), New Vec2(100, 40), New Vec2(60, 80), New Vec2(0, 80)]))
			
		poly1.Translate(-poly1.GetBounds().width / 2, -poly1.GetBounds().height / 2)
		pool = New Stack<Polygon>()
		pool.Push(poly1)
		quadTree = New QuadTree(0, 0, DeviceWidth(), DeviceHeight())
		response = New Response()
		For Local i:Int = 0 To 300
			Local p:Polygon = New Polygon(New Vec2(Rnd(100, DeviceWidth()-100), Rnd(100, DeviceHeight()-100)), 
					New VecStack([New Vec2(0, 0), New Vec2(10, 0), New Vec2(10, 10), New Vec2(0, 10)]))
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
				quadTree.Insert(t)
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