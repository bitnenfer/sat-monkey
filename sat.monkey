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
Import sat.box
Import sat.polygon
Import sat.circle
Import sat.vecstack

Class SAT
	
	Private
	
	Const LEFT_VORONI_REGION:Int = -1
	Const MIDDLE_VORONI_REGION:Int = 0
	Const RIGHT_VORONI_REGION:Int = 1
	
	Global T_VECTORS:VecStack = New VecStack([
		New Vector(), New Vector(), New Vector(),
		New Vector(), New Vector(), New Vector(),
		New Vector(), New Vector(), New Vector()])
		
	Global T_ARRAYS:Stack<FloatStack> = New Stack<FloatStack>([
		New FloatStack(), New FloatStack(), New FloatStack(),
		New FloatStack()])
		
	Global T_RESPONSE:Response = New Response()
	Global UNIT_SQUARE:Polygon = New Box(New Vector(), 1, 1).ToPolygon()
	
	Function FlattenPointsOn:Void (points:VecStack, normal:Vector, result:FloatStack)
		Local min:Float = SAT.MAX_VALUE
		Local max:Float = -SAT.MAX_VALUE
		Local len:Int = points.Length()
		Local i:Int
		
		For i = 0 To len - 1
			Local dot:Float = points.Get(i).Dot(normal)
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
		Local rangeA:FloatStack = T_ARRAYS.Pop()
		Local rangeB:FloatStack = T_ARRAYS.Pop()
		Local offsetV:Vector = T_VECTORS.Pop().Copy(bPos).Sub(aPos)
		Local projectedOffset:Float = offsetV.Dot(axis)
		
		
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
			Local overlap:Float = 0
			If (rangeA.Get(0) < rangeB.Get(0))
				response.aInB = False
				If (rangeA.Get(1) < rangeB.Get(1))
					overlap = rangeA.Get(1) - rangeB.Get(0)
					response.bInA = False
				Else
					Local option1:Float = rangeA.Get(1) - rangeB.Get(0)
					Local option2:Float = rangeB.Get(1) - rangeA.Get(0)
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
					Local option1:Float = rangeA.Get(1) - rangeB.Get(0)
					Local option2:Float = rangeB.Get(1) - rangeA.Get(0)
					If (option1 < option2)
						overlap = option1
					Else
						overlap = -option2
					Endif
				Endif
			Endif
			Local absOverlap:Float = Abs(overlap)
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
		Local len2:Float = line.Length2()
		Local dp:Float = point.Dot(line)
		
		If (dp < 0)
			Return SAT.LEFT_VORONI_REGION
		Elseif (dp > len2)
			Return SAT.RIGHT_VORONI_REGION
		Else
			Return SAT.MIDDLE_VORONI_REGION
		End
	End Function
	
	Public
	
	Const MAX_VALUE:Float = 1.7976931348623157e+308
	
	Function PointInCircle:Bool (p:Vector, c:Circle)
		Local differenceV:Vector = T_VECTORS.Pop().Copy(p).Sub(c.position)
		Local radiusSq:Float = c.radius * c.radius
		Local distanceSq:Float = differenceV.Length2()
		
		Return distanceSq <= radiusSq
	End Function
	
	Function PointInPolygon:Bool (p:Vector, poly:Polygon)
		Local result:Bool
		
		UNIT_SQUARE.position.Copy(p)
		T_RESPONSE.Clear()
		result = TestPolygonPolygon(UNIT_SQUARE, poly, T_RESPONSE)
		If (result)
			result = T_RESPONSE.aInB
		Endif
		
		Return result
	End Function
	
	Function TestCircleCircle:Bool (a:Circle, b:Circle, response:Response = Null)
		Local differenceV:Vector = T_VECTORS.Pop().Copy(b.position).Sub(a.position)
		Local totalRadius:Float = a.radius + b.radius
		Local totalRadiusSq:Float = totalRadius * totalRadius
		Local distanceSq:Float = differenceV.Length2()
		Local dist:Float
		
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
		Local circlePos:Vector = T_VECTORS.Pop().Copy(circle.position).Sub(polygon.position)
		Local radius:Float = circle.radius
		Local radius2:Float = radius * radius
		Local points:VecStack = polygon.calcPoints
		Local len:Int = points.Length()
		Local edge:Vector = T_VECTORS.Pop()
		Local point:Vector = T_VECTORS.Pop()
		Local i:Int
		
		For i = 0 To len - 1
			Local tNext:Float
			Local tPrev:Float
			Local overlap:Float = 0
			Local overlapN:Vector = Null
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
			Local region:Int = VoroniRegion(edge, point)
			If (region = SAT.LEFT_VORONI_REGION)
				edge.Copy(polygon.edges.Get(tPrev))
				Local point2:Vector = T_VECTORS.Pop().Copy(circlePos).Sub(points.Get(tPrev))
				region = VoroniRegion(edge, point2)
				If (region = SAT.RIGHT_VORONI_REGION)
					Local dist1:Float = point.Length()
					If (dist1 > radius)
						T_VECTORS.Push(circlePos)
						T_VECTORS.Push(edge)
						T_VECTORS.Push(point)
						T_VECTORS.Push(point2)
						
						Return False
					ElseIf (response <> Null)
						response.bInA = False
						overlapN = point.Normalize()
						overlap = radius - dist1
					Endif
				Endif
				T_VECTORS.Push(point2)
			Elseif (region = SAT.RIGHT_VORONI_REGION)
				edge.Copy(polygon.edges.Get(tNext))
				point.Copy(circlePos).Sub(points.Get(tNext))
				region = VoroniRegion(edge, point)
				If (region = SAT.LEFT_VORONI_REGION)
					Local dist2:Float = point.Length()
					If (dist2 > radius)
						T_VECTORS.Push(circlePos)
						T_VECTORS.Push(edge)
						T_VECTORS.Push(point)
						
						Return False
					Elseif (response <> Null)
						response.bInA = False
						overlapN = point.Normalize()
						overlap = radius - dist2
					Endif
				Endif
			Else
				Local normal:Vector = edge.Perp().Normalize()
				Local dist3:Float = point.Dot(normal)
				Local distAbs:float = Abs(dist3)
				If (dist3 > 0 And distAbs > radius)
					T_VECTORS.Push(circlePos)
					T_VECTORS.Push(normal)
					T_VECTORS.Push(point)
					
					Return False
				Elseif (response <> Null)
					
					overlapN = normal
					overlap = radius - dist3
					If (dist3 >= 0 Or overlap < 2 * radius)
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
		Local result:Bool = TestPolygonCircle(polygon, circle, response)
		Local a:iBase
		Local aInB:Bool
		
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
		Local aPoints:VecStack = a.calcPoints
		Local aLen:Int = aPoints.Length()
		Local bPoints:VecStack = b.calcPoints
		Local bLen:Int = bPoints.Length()
		Local i:Int
		
		For i = 0 To aLen - 1
			If (IsSeparatingAxis(a.position, b.position, aPoints, bPoints, a.normals.Get(i), response))
				Return False
			Endif
		Next
		
		For i = 0 To bLen - 1
			If (IsSeparatingAxis(a.position, b.position, aPoints, bPoints, b.normals.Get(i), response))
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
End