#REM
	Version 0.4 - Copyright 2014 -  Jim Riecken <jimr@jimr.ca>
	Released under the MIT License - https://github.com/jriecken/sat-js
	A simple library for determining intersections of circles and
	polygons using the Separating Axis Theorem.
	@preserve SAT.js - Version 0.4 - Copyright 2014 - Jim Riecken <jimr@jimr.ca> - 
	released under the MIT License. https://github.com/jriecken/sat-js
	
	Ported to Monkey by Felipe Alfonso <contact@shin.cl> -
	https://github.com/ilovepixel/sat-monkey/
#END

Strict

Import sat.vector
Import sat.response
Import sat.rectangle
Import sat.polygon
Import sat.circle
Import sat.vecstack
Import sat.quadtree

Class SAT
	
	Private
	
	Const LEFT_VORONI_REGION:Int = -1
	Const MIDDLE_VORONI_REGION:Int = 0
	Const RIGHT_VORONI_REGION:Int = 1
	
	' Caching
	
	Global tNext:Float
	Global tPrev:Float
	Global overlap:Float
	Global overlapN:Vector
	Global region:Int
	Global point2:Vector
	Global dist:Float
	Global normal:Vector
	Global distAbs:Float
	Global rangeA:FloatStack
	Global rangeB:FloatStack
	Global offsetV:Vector
	Global projectedOffset:Float
	Global option1:Float
	Global option2:Float
	Global absOverlap:Float
	Global min:Float
	Global max:Float
	Global len:Int
	Global i:Int
	Global dot:Float
	Global len2:Float
	Global dp:Float
	Global differenceV:Vector
	Global radiusSq:Float
	Global distanceSq:Float
	Global result:Bool
	Global totalRadius:Float
	Global totalRadiusSq:Float
	Global circlePos:Vector
	Global radius:Float
	Global radius2:Float
	Global points:VecStack
	Global edge:Vector
	Global point:Vector
	Global a:iSAT
	Global aInB:Bool
	Global aPoints:VecStack
	Global aLen:Int
	Global bPoints:VecStack
	Global bLen:Int
	
	Global T_VECTORS:VecStack = New VecStack([
		New Vector(), New Vector(), New Vector(),
		New Vector(), New Vector(), New Vector(),
		New Vector(), New Vector(), New Vector()])
		
	Global T_ARRAYS:Stack<FloatStack> = New Stack<FloatStack>([
		New FloatStack(), New FloatStack(), New FloatStack(),
		New FloatStack()])
		
	Global T_RESPONSE:Response = New Response()
	Global UNIT_SQUARE:Polygon = New Rectangle(New Vector(), 1, 1).ToPolygon()
	
	Function FlattenPointsOn:Void (points:VecStack, normal:Vector, result:FloatStack)
		min = SAT.MAX_VALUE
		max = -SAT.MAX_VALUE
		len = points.Length()
		
		For i = 0 To len - 1
			dot = points.Get(i).Dot(normal)
			If (dot < min) 
				min = dot
			Endif
			If (dot > max)
				max = dot
			Endif
		Next
		If (result.Length() = 0)
			result.Push(min)
			result.Push(max)
		Else
			result.Set(0, min)
			result.Set(1, max)
		EndIf
	End Function
	
	Function IsSeparatingAxis:Bool (aPos:Vector, bPos:Vector, aPoints:VecStack, bPoints:VecStack, axis:Vector, response:Response = Null)
		rangeA = T_ARRAYS.Pop()
		rangeB = T_ARRAYS.Pop()
		offsetV = T_VECTORS.Pop().Copy(bPos).Sub(aPos)
		projectedOffset = offsetV.Dot(axis)
		
		SAT.FlattenPointsOn(aPoints, axis, rangeA)
		SAT.FlattenPointsOn(bPoints, axis, rangeB)
		
		rangeB.Set(0, rangeB.Get(0) + projectedOffset)
		rangeB.Set(1, rangeB.Get(1) + projectedOffset)
		If (rangeA.Get(0) > rangeB.Get(1) Or rangeB.Get(0) > rangeA.Get(1))
			T_VECTORS.Push(offsetV)
			T_ARRAYS.Push(rangeA)
			T_ARRAYS.Push(rangeB)
			
			Return True
		Endif
		
		If (response <> Null)
			overlap = 0
			If (rangeA.Get(0) < rangeB.Get(0))
				response.aInB = False
				If (rangeA.Get(1) < rangeB.Get(1))
					overlap = rangeA.Get(1) - rangeB.Get(0)
					response.bInA = False
				Else
					option1 = rangeA.Get(1) - rangeB.Get(0)
					option2 = rangeB.Get(1) - rangeA.Get(0)
					If (option1 < option2)
						overlap = option1
					Else
						overlap = -option2
					Endif
				Endif
			Else
				response.bInA = False
				If (rangeA.Get(1) > rangeB.Get(1))
					overlap = rangeA.Get(0) - rangeB.Get(1)
					response.aInB = False
				Else
					option1 = rangeA.Get(1) - rangeB.Get(0)
					option2 = rangeB.Get(1) - rangeA.Get(0)
					If (option1 < option2)
						overlap = option1
					Else
						overlap = -option2
					Endif
				Endif
			Endif
			absOverlap= Abs(overlap)
			If (absOverlap < response.overlap)
				response.overlap = absOverlap
				response.overlapN.Copy(axis)
				If (overlap < 0)
					response.overlapN.Reverse()
				Endif
			Endif
		Endif
		T_VECTORS.Push(offsetV)
		T_ARRAYS.Push(rangeA)
		T_ARRAYS.Push(rangeB)
		
		Return False
	End Function
	
	Function VoroniRegion:Int (line:Vector, point:Vector)
		len2 = line.Length2()
		dp = point.Dot(line)
		
		If (dp < 0)
			Return SAT.LEFT_VORONI_REGION
		Elseif (dp > len2)
			Return SAT.RIGHT_VORONI_REGION
		Else
			Return SAT.MIDDLE_VORONI_REGION
		End
	End Function
	
	Public
	
	Const MAX_VALUE:Float = 99999999999999
	Global TEST_BOUNDS_FIRST:Bool = True
	
	Function PointInCircle:Bool (p:Vector, c:Circle)
		differenceV = T_VECTORS.Pop().Copy(p).Sub(c.position)
		radiusSq = c.radius * c.radius
		distanceSq = differenceV.Length2()
		
		Return distanceSq <= radiusSq
	End Function
	
	Function PointInPolygon:Bool (p:Vector, poly:Polygon)		
		UNIT_SQUARE.position.Copy(p)
		T_RESPONSE.Clear()
		result = TestPolygonPolygon(UNIT_SQUARE, poly, T_RESPONSE)
		If (result)
			result = T_RESPONSE.aInB
		Endif
		
		Return result
	End Function
	
	Function TestCircleCircle:Bool (a:Circle, b:Circle, response:Response = Null)
		If (TEST_BOUNDS_FIRST And Not TestAABB(a.GetBounds(), b.GetBounds()))
			Return False
		Endif
		
		differenceV = T_VECTORS.Pop().Copy(b.position).Sub(a.position)
		totalRadius = a.radius + b.radius
		totalRadiusSq = totalRadius * totalRadius
		distanceSq= differenceV.Length2()
		
		If (distanceSq > totalRadiusSq)
			T_VECTORS.Push(differenceV)
			
			Return False
		Endif
		If (response <> Null)
			dist = Sqrt(distanceSq)
			response.a = a
			response.b = b
			response.overlap = totalRadius - dist
			response.overlapN.Copy(differenceV.Normalize())
			response.overlapV.Copy(differenceV).Scale(response.overlap)
			If (a.radius <= b.radius And dist <= b.radius - a.radius)
				response.aInB = True
			Else
				response.aInB = False
			Endif
			If (b.radius <= a.radius And dist <= a.radius - b.radius)
				response.bInA = True
			Else
				response.bInA = False
			Endif
			T_VECTORS.Push(differenceV)
			
			
		Endif
		Return True
	End Function
	
	Function TestPolygonCircle:Bool (polygon:Polygon, circle:Circle, response:Response = Null)
		If (TEST_BOUNDS_FIRST And Not TestAABB(polygon.GetBounds(), circle.GetBounds()))
			Return False
		Endif
		
		circlePos = T_VECTORS.Pop().Copy(circle.position).Sub(polygon.position)
		radius = circle.radius
		radius2 = radius * radius
		points = polygon.calcPoints
		len = points.Length()
		edge = T_VECTORS.Pop()
		point = T_VECTORS.Pop()
		
		For i = 0 To len - 1
			tNext = 0
			tPrev = 0
			overlap = 0
			overlapN = Null
			region = 0
			point2 = Null
			dist = 0
			normal = Null
			distAbs = 0
			
			If (i = len - 1)
				tNext = 0
			Else
				tNext = i + 1
			Endif
			If (i = 0)
				tPrev = len - 1
			Else
				tPrev = i - 1
			Endif
			
			edge.Copy(polygon.edges.Get(i))
			point.Copy(circlePos).Sub(points.Get(i))
			If (response <> Null And point.Length2() > radius2)
				response.aInB = False
			Endif
			region = VoroniRegion(edge, point)
			If (region = SAT.LEFT_VORONI_REGION)
				edge.Copy(polygon.edges.Get(tPrev))
				point2 = T_VECTORS.Pop().Copy(circlePos).Sub(points.Get(tPrev))
				region = VoroniRegion(edge, point2)
				If (region = SAT.RIGHT_VORONI_REGION)
					dist = point.Length()
					If (dist > radius)
						T_VECTORS.Push(circlePos)
						T_VECTORS.Push(edge)
						T_VECTORS.Push(point)
						T_VECTORS.Push(point2)
						
						Return False
					ElseIf (response <> Null)
						response.bInA = False
						overlapN = point.Normalize()
						overlap = radius - dist
					Endif
				Endif
				T_VECTORS.Push(point2)
			Elseif (region = SAT.RIGHT_VORONI_REGION)
				edge.Copy(polygon.edges.Get(tNext))
				point.Copy(circlePos).Sub(points.Get(tNext))
				region = VoroniRegion(edge, point)
				If (region = SAT.LEFT_VORONI_REGION)
					dist = point.Length()
					If (dist > radius)
						T_VECTORS.Push(circlePos)
						T_VECTORS.Push(edge)
						T_VECTORS.Push(point)
						
						Return False
					Elseif (response <> Null)
						response.bInA = False
						overlapN = point.Normalize()
						overlap = radius - dist
					Endif
				Endif
			Else
				normal = edge.Perp().Normalize()
				dist = point.Dot(normal)
				distAbs = Abs(dist)
				If (dist > 0 And distAbs > radius)
					T_VECTORS.Push(circlePos)
					T_VECTORS.Push(normal)
					T_VECTORS.Push(point)
					
					Return False
				Elseif (response <> Null)
					
					overlapN = normal
					overlap = radius - dist
					If (dist >= 0 Or overlap < 2 * radius)
						response.bInA = False
					Endif
				Endif
			Endif
			If (overlapN <> Null And response <> Null And Abs(overlap) < Abs(response.overlap))
				response.overlap = overlap
				
				response.overlapN.Copy(overlapN)
			Endif
		Next
		If (response <> Null)
			response.a = polygon
			response.b = circle
			response.overlapV.Copy(response.overlapN).Scale(response.overlap)
		Endif
		T_VECTORS.Push(circlePos)
		T_VECTORS.Push(edge)
		T_VECTORS.Push(point)
		
		Return True
	End Function
	
	Function TestCirclePolygon:Bool (circle:Circle, polygon:Polygon, response:Response = Null)
		result = TestPolygonCircle(polygon, circle, response)
		If (result And response <> Null)
			a = response.a
			aInB = response.aInB
			response.overlapN.Reverse()
			response.overlapV.Reverse()
			response.a = response.b
			response.b = a
			response.aInB = response.bInA
			response.bInA = aInB
		Endif
		
		Return result
	End Function
	
	Function TestPolygonPolygon:Bool (a:Polygon, b:Polygon, response:Response = Null)
		If (TEST_BOUNDS_FIRST And Not TestAABB(a.GetBounds(), b.GetBounds()))
			Return False
		Endif
		
		aPoints = a.calcPoints
		aLen = aPoints.Length()
		bPoints = b.calcPoints
		bLen = bPoints.Length()
		Local j:Int
		
		For j = 0 To aLen - 1
			If (IsSeparatingAxis(a.position, b.position, aPoints, bPoints, a.normals.Get(j), response))
				Return False
			Endif
		Next
		
		For j = 0 To bLen - 1
			If (IsSeparatingAxis(a.position, b.position, aPoints, bPoints, b.normals.Get(j), response))
				Return False
			Endif
		Next
		If (response <> Null)
			response.a = a
			response.b = b
			response.overlapV.Copy(response.overlapN).Scale(response.overlap)
		Endif
		Return True
	End Function
	
	Function TestAABB:Bool (a:Rectangle, b:Rectangle)
		Return Not (b.position.x > a.position.x + a.width Or
			b.position.x + b.width < a.position.x Or
			b.position.y > a.position.y + a.height Or
			b.position.y + b.height < a.position.y)
	End
End