#REM
	
	For using this test you need to download Capuchin.
	Capuchin is a module developed to test your code.
	URL: https://github.com/ilovepixel/capuchin/
	
#End

Strict

Import mojo
Import sat
Import capuchin

Class TestPolygonToPolygon Extends Test Implements iSpec
	Method New()
		Super.New()
		It("Should collide correctly", Self)
		It("Should return the correct value for overlap", Self)
		It("Should return the correct separation value for overlap on X", Self)
		It("Should return the correct separation value for overlap on Y", Self)
	End
	
	Method Execute:Void (testNum:Int, spec:Spec)	
		Select (testNum)
			Case 0
				Local polygon1:Polygon
				Local polygon2:Polygon
				Local collide:Bool = False
				
				polygon1 = New Polygon(0, 0, New VecStack([
					New Vec2(0, 0), New Vec2(40, 0), New Vec2(40, 40), New Vec2(0, 40)]))
					
				polygon2 = New Polygon(30, 0, New VecStack([
					New Vec2(0, 0), New Vec2(30, 0), New Vec2(0, 30)]))
					
				collide = SAT.TestPolygonPolygon(polygon1, polygon2)
				spec.Expect(collide).BeTrue()
				spec.Done()
				
			Case 1
				Local polygon1:Polygon
				Local polygon2:Polygon
				Local response:Response
				
				response = New Response()
				polygon1 = New Polygon(0, 0, New VecStack([
					New Vec2(0, 0), New Vec2(40, 0), New Vec2(40, 40), New Vec2(0, 40)]))
					
				polygon2 = New Polygon(30, 0, New VecStack([
					New Vec2(0, 0), New Vec2(30, 0), New Vec2(0, 30)]))
					
				SAT.TestPolygonPolygon(polygon1, polygon2, response)
				spec.Expect(response.overlap).ToEqual(10.0)
				spec.Done()
			Case 2
				Local polygon1:Polygon
				Local polygon2:Polygon
				Local response:Response
				
				response = New Response()
				polygon1 = New Polygon(0, 0, New VecStack([
					New Vec2(0, 0), New Vec2(40, 0), New Vec2(40, 40), New Vec2(0, 40)]))
					
				polygon2 = New Polygon(30, 0, New VecStack([
					New Vec2(0, 0), New Vec2(30, 0), New Vec2(0, 30)]))
					
				SAT.TestPolygonPolygon(polygon1, polygon2, response)
				spec.Expect(response.overlapV.x).ToEqual(10.0)
				spec.Done()
			Case 3
				Local polygon1:Polygon
				Local polygon2:Polygon
				Local response:Response
				
				response = New Response()
				polygon1 = New Polygon(0, 0, New VecStack([
					New Vec2(0, 0), New Vec2(40, 0), New Vec2(40, 40), New Vec2(0, 40)]))
					
				polygon2 = New Polygon(30, 0, New VecStack([
					New Vec2(0, 0), New Vec2(30, 0), New Vec2(0, 30)]))
					
				SAT.TestPolygonPolygon(polygon1, polygon2, response)
				spec.Expect(response.overlapV.y).ToEqual(0.0)
				spec.Done()
		End
	End
End

Class TestPolygonToCircle Extends Test Implements iSpec
	Method New()
		Super.New()
		It("Should collide correctly", Self)
		It("Should return the correct value for overlap", Self)
		It("Should return the correct separation value for overlap on X", Self)
		It("Should return the correct separation value for overlap on Y", Self)
	End
	
	Method Execute:Void (testNum:Int, spec:Spec)	
		Select (testNum)
			Case 0
				Local circle:Circle
				Local polygon:Polygon
				Local collide:Bool = False
				
				circle = New Circle(50, 50, 20)
				polygon = New Polygon(0, 0, New VecStack([
				New Vec2(0, 0), New Vec2(40, 0), New Vec2(40, 40), New Vec2(0, 40)]))
				collide = SAT.TestPolygonCircle(polygon, circle)
				spec.Expect(collide).BeTrue()
				spec.Done()
			Case 1
				Local circle:Circle
				Local polygon:Polygon
				Local response:Response
	
				response = New Response()
				circle = New Circle(50, 50, 20)
				polygon = New Polygon(0, 0, New VecStack([
				New Vec2(0, 0), New Vec2(40, 0), New Vec2(40, 40), New Vec2(0, 40)]))
				SAT.TestPolygonCircle(polygon, circle, response)
				' I use ceil because the number it returns it's about the same but
				' but with a decimal difference
				spec.Expect(Ceil(response.overlap)).ToEqual(Ceil(5.86)) 
				spec.Done()
			Case 2
				Local circle:Circle
				Local polygon:Polygon
				Local response:Response
	
				response = New Response()
				circle = New Circle(50, 50, 20)
				polygon = New Polygon(0, 0, New VecStack([
				New Vec2(0, 0), New Vec2(40, 0), New Vec2(40, 40), New Vec2(0, 40)]))
				SAT.TestPolygonCircle(polygon, circle, response)
				' I use ceil because the number it returns it's about the same but
				' but with a decimal difference
				spec.Expect(Ceil(response.overlapV.x)).ToEqual(Ceil(4.14)) 
				spec.Done()
			Case 3
				Local circle:Circle
				Local polygon:Polygon
				Local response:Response
	
				response = New Response()
				circle = New Circle(50, 50, 20)
				polygon = New Polygon(0, 0, New VecStack([
				New Vec2(0, 0), New Vec2(40, 0), New Vec2(40, 40), New Vec2(0, 40)]))
				SAT.TestPolygonCircle(polygon, circle, response)
				' I use ceil because the number it returns it's about the same but
				' but with a decimal difference
				spec.Expect(Ceil(response.overlapV.y)).ToEqual(Ceil(4.14)) 
				spec.Done()
		End
	End
End

Class TestNoCollisionRectangle Extends Test Implements iSpec
	
	Method New ()
		Super.New()
		It("Should not detect collision if polygons are not colliding", Self)
	End
	
	Method Execute:Void (testNum:Int, spec:Spec)
		Select (testNum)
			Case 0
				Local box1:Polygon
				Local box2:Polygon
				Local collide:Bool = True
				
				box1 = New Rectangle(0, 0, 20, 20).ToPolygon()
				box2 = New Rectangle(100, 100, 20, 20).ToPolygon()
				collide = SAT.TestPolygonPolygon(box1, box2)
				spec.Expect(collide).BeFalse()
				spec.Done()
		End
	End
End

Class TestPointOverPolygon Extends Test Implements iSpec
	Method New()
		Super.New()
		It("Should not collide point on polygon", Self)
		It("Should collide point on polygon", Self)
	End
	
	Method Execute:Void (testNum:Int, spec:Spec)
		Select (testNum)
			Case 0
				Local triangle:Polygon
				Local collide:Bool = False
				Local point:Vec2
				
				triangle = New Polygon(30, 0, New VecStack([
					New Vec2(), New Vec2(30, 0), New Vec2(0, 30)]))
				point = New Vec2(0, 0)
				
				collide = SAT.PointInPolygon(point, triangle)
				spec.Expect(collide).BeFalse()
				spec.Done()
			Case 1
				Local triangle:Polygon
				Local collide:Bool = False
				Local point:Vec2
				
				triangle = New Polygon(30, 0, New VecStack([
					New Vec2(), New Vec2(30, 0), New Vec2(0, 30)]))
				point = New Vec2(35, 5)
				
				collide = SAT.PointInPolygon(point, triangle)
				spec.Expect(collide).BeTrue()
				spec.Done()
		End
	End
End

Class TestPointOverCircle Extends Test Implements iSpec
	Method New()
		Super.New()
		It("Should not collide point on circle", Self)
		It("Should collide point on circle", Self)
	End
	
	Method Execute:Void (testNum:Int, spec:Spec)
		Select (testNum)
			Case 0
				Local circle:Circle
				Local collide:Bool = False
				Local point:Vec2
				
				circle = New Circle(100, 100, 20)
				point = New Vec2(0, 0)
				
				collide = SAT.PointInCircle(point, circle)
				spec.Expect(collide).BeFalse()
				spec.Done()
			Case 1
				Local circle:Circle
				Local collide:Bool = False
				Local point:Vec2
				
				circle = New Circle(100, 100, 20)
				point = New Vec2(110, 110)
				
				collide = SAT.PointInCircle(point, circle)
				spec.Expect(collide).BeTrue()
				spec.Done()
		End
	End
End

Class TestQuadTree Extends Test Implements iSpec
	Method New()
		Super.New()
		It("Should subdivide when more than the limit of objects are inserted", Self)
		It("Should clear the nodes when the quadtree is cleared", Self)
		It("Should return the correct objects inside the node that is being checked", Self)
	End
	
	Method Execute:Void (testNum:Int, spec:Spec)
		Select (testNum)
			Case 0
				Local quadTree:QuadTree
				Local result:Int = 0
				Local nodes:QuadTree[]
				Local circle:Circle
				Local poly:Polygon
				Local t:Int = 0
				
				quadTree = New QuadTree(0, 0, DeviceWidth(), DeviceHeight())
				For Local i:Int = 0 Until 5
					If (t = 0)
						circle = New Circle(Rnd(0, DeviceWidth()), Rnd(0, DeviceHeight()), 10)
						quadTree.Insert(circle)
						t = 1
					Else
						poly = New Polygon(Rnd(0, DeviceWidth()), Rnd(0, DeviceHeight()),
							New VecStack([New Vec2(0, 0), New Vec2(100, 0), New Vec2(100, 100), New Vec2(0, 100)]))
						quadTree.Insert(poly)
						t = 0
					Endif
				Next
				nodes = quadTree.GetNodes()
				For Local i:Int = 0 To nodes.Length() - 1
					If (nodes[i] <> Null)
						result += 1
					Endif
				Next
				spec.Expect(result).ToEqual(4)
				spec.Done()
			Case 1
				Local quadTree:QuadTree
				Local result:Int = 0
				Local nodes:QuadTree[]
				Local circle:Circle
				Local poly:Polygon
				Local t:Int = 0
				
				quadTree = New QuadTree(0, 0, DeviceWidth(), DeviceHeight())
				For Local i:Int = 0 Until 5
					If (t = 0)
						circle = New Circle(Rnd(0, DeviceWidth()), Rnd(0, DeviceHeight()), 10)
						quadTree.Insert(circle)
						t = 1
					Else
						poly = New Polygon(Rnd(0, DeviceWidth()), Rnd(0, DeviceHeight()),
							New VecStack([New Vec2(0, 0), New Vec2(100, 0), New Vec2(100, 100), New Vec2(0, 100)]))
						quadTree.Insert(poly)
						t = 0
					Endif
				Next
				quadTree.Clear()
				nodes = quadTree.GetNodes()
				For Local i:Int = 0 To nodes.Length() - 1
					If (nodes[i] <> Null)
						result += 1
					Endif
				Next
				spec.Expect(result).ToEqual(0)
				spec.Done()
			Case 2
				Local quadTree:QuadTree
				Local returnObjects:Stack<iSAT>
				Local result:Int = 0
				Local nodes:QuadTree[]
				Local circle:Circle
				Local poly:Polygon
				Local t:Int = 0
				
				quadTree = New QuadTree(0, 0, DeviceWidth(), DeviceHeight())
				For Local i:Int = 0 Until 5
					circle = New Circle(0, 0, 10)
					quadTree.Insert(circle)
				Next
				
				circle = New Circle(DeviceWidth() -100, DeviceHeight() -100, 10)
				poly = New Polygon(DeviceWidth() -20, DeviceHeight() -50, New VecStack([
					New Vec2(0, 0), New Vec2(100, 0)]))
				
				quadTree.Insert(circle)
				quadTree.Insert(poly)
				
				returnObjects = quadTree.Retrieve(circle)
				
				' I am checking 1 because 0 is the circle
				spec.Expect((Polygon(returnObjects.Get(1)) = poly)).BeTrue()
				spec.Done()
		End	
	End
End

Class SATTest Extends App
	
	Field testEnv:TestEnviroment
	
	Method OnCreate:Int ()
		TestEnviroment.PRINT_TEST = True
		testEnv = New TestEnviroment()
		
		testEnv.Describe("Polygon To Polygon Collision", New TestPolygonToPolygon())
		testEnv.Describe("Polygon To Circle Collision", New TestPolygonToCircle())
		testEnv.Describe("Polygons not Colliding", New TestNoCollisionRectangle())
		testEnv.Describe("Point over Polygon", New TestPointOverPolygon())
		testEnv.Describe("Point over Circle", New TestPointOverCircle())
		testEnv.Describe("QuadTree Test", New TestQuadTree())
		
		testEnv.Start()
		SetUpdateRate(60)
		Return 0
	End
	
	Method OnUpdate:Int ()
		testEnv.Update()
		Return 0
	End
	
	Method OnRender:Int ()
		Cls()
		testEnv.Draw()
		Return 0
	End
	
End

Function Main:Int ()
	New SATTest()
	Return 0
End