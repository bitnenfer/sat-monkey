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

Import sat
Import diddy.functions

Class QuadTree
	
	Private
	
	Field _children:iBase[]
	
	Field bounds:Box
	Field depth:Int
	Field maxDepth:Int
	Field maxChildren:Int
	Field children:Stack<iBase>
	Field nodes:QuadTree[4]
	Field hwidth:Float
	Field hheight:Float
	Field indexes:Int[4]
	Field avg:Int = 0
	Field frames:Int = 0
	Field peak:Int = 0
	Field x:Float
	Field y:Float
	Field width:Float
	Field height:Float
	Field returnObjects:Stack<iBase>
	
	Public
	
	Const TOP_LEFT:Int = 0
	Const TOP_RIGHT:Int = 1
	Const BOTTOM_LEFT:Int = 2
	Const BOTTOM_RIGHT:Int = 3
	Const NONE:Int = -1
	Method New (x:Float, y:Float, w:Float, h:Float, depth:Int = 0, maxDepth:Int = 4, maxChildren:Int = 4)
		Self.depth = depth
		Self.maxDepth = 4
		Self.maxChildren = maxChildren
		Self.hwidth = w / 2
		Self.hheight = h / 2
		Self.children = New Stack<iBase>()
		Self.indexes = [-1, -1, -1, -1]
		Self.x = x
		Self.y = y
		Self.width = w
		Self.height = h
		returnObjects = New Stack<iBase>()
	End
	
	Method Split:Void ()
		Local depth:Int = Self.depth + 1
		
		nodes[0] = New QuadTree(x, y, hwidth, hheight, depth, maxDepth, maxChildren)
		nodes[1] = New QuadTree(x + hwidth, y, hwidth, hheight, depth, maxDepth, maxChildren)
		nodes[2] = New QuadTree(x, y + hheight, hwidth, hheight, depth, maxDepth, maxChildren)
		nodes[3] = New QuadTree(x + hwidth, y + hheight, hwidth, hheight, depth, maxDepth, maxChildren)
	End
	
	Method GetIndex:Int (base:iBase)
		Local b:Box = base.GetBounds()
		Local bx:Float = b.position.x
		Local by:Float = b.position.y
		Local index:Int = -1
		Local i:Int
		Local len:Int = nodes.Length() - 1
		
		If (bx < x Or bx > x + width Or by < y Or by > y + height) Return -1
		
		If (bx < x + hwidth)
			If (by < y + hheight)
				index = BOTTOM_LEFT
			Else
				index = TOP_LEFT
			Endif
		Else
			If (by < y + hheight)
				index = BOTTOM_RIGHT
			Else
				index = BOTTOM_RIGHT
			Endif
		Endif
		Return index
	End
	
	Method GetIndexes:Int[] (base:iBase)
		Local b:Box = base.GetBounds()
		Local bx:Float = b.position.x
		Local by:Float = b.position.y
		Local i:Int
		Local len:Int = nodes.Length() - 1
		
		indexes = [-1, -1, -1, -1]
		
		If (bx <= x + hwidth)
			If (by <= y + hheight)
				For i = 0 To len
					If (indexes[i] = -1)
						indexes[i] = TOP_LEFT
						Exit
					Endif
				Next
				If (bx + b.width >= x + hwidth)
					For i = 0 To len
						If (indexes[i] = -1)
							indexes[i] = TOP_RIGHT
							Exit
						Endif
					Next
				Endif
			Endif
			If (by + b.height >= y + hheight)
				For i = 0 To len
					If (indexes[i] = -1)
						indexes[i] = BOTTOM_LEFT
						Exit
					Endif
				Next
				If (bx + b.width >= x + hwidth)
					For i = 0 To len
						If (indexes[i] = -1)
							indexes[i] = BOTTOM_RIGHT
							Exit
						Endif
					Next
				Endif
			Endif
		Else
			If (by <= y + hheight)
				For i = 0 To len
					If (indexes[i] = -1)
						indexes[i] = TOP_RIGHT
						Exit
					Endif
				Next
				If (by + b.height > y + hheight)
					For i = 0 To len
						If (indexes[i] = -1)
							indexes[i] = BOTTOM_RIGHT
							Exit
						Endif
					Next
				Endif
			Endif
			If (by >= y + hheight)
				For i = 0 To len
					If (indexes[i] = -1)
						indexes[i] = BOTTOM_RIGHT
						Exit
					Endif
				Next
			Endif
		Endif
		
		Return indexes
	End
	
	Method Insert:Void (base:iBase)
		Local i:Int
		Local len:Int
		If (nodes[0] <> Null)
			Local indexes:Int[] = GetIndexes(base)
			len = indexes.Length() - 1
			For i = 0 To len
				If (indexes[i] <> -1) 
					nodes[indexes[i]].Insert(base)
				Endif
			Next
		Else
			_children = _children.Resize(_children.Length() + 1)
			_children[_children.Length() - 1] = base
			If (_children.Length() > maxChildren And depth < maxDepth)
				Split()
				len = _children.Length() - 1
				For i = 0 To len
					Insert(_children[i])
				Next
				_children = _children.Resize(0)
			Endif		
		Endif
	End
	
	Method Length:Int ()
		Return _children.Length()
	End
	
	Method Retrieve:Stack<iBase> (base:iBase)
		returnObjects.Clear()
		If (nodes[0] <> Null)
			returnObjects.Clear()
			Local indexes:Int[] = GetIndexes(base)
			
			For Local i:Int = 0 To indexes.Length() - 1
				If (indexes[i] <> -1) 
					returnObjects.Push(nodes[indexes[i]].Retrieve(base).ToArray())
				EndIf
			Next
		Else
			returnObjects.Push(_children)
		Endif
		Return returnObjects	
	End
	
	Method Clear:Void ()
		Local i:Int
		Local len:Int = nodes.Length() - 1
		
		For i = 0 To len
			If (nodes[i] <> Null)
				nodes[i].Clear()
				nodes[i] = Null
			Endif
		Next
		
		Self.children.Clear()
	End
	
	Method DebugDraw:Void ()
		Local i:Int
		Local len:Int = nodes.Length() - 1
		
		If (nodes[0] <> Null)
			For i = 0 To len
				nodes[i].DebugDraw()
			Next
		Endif
		DrawLine(x, y, x + width, y)
		DrawLine(x + width, y, x + width, y + height)
		DrawLine(x + width, y + height, x, y + height)
		DrawLine(x, y + height, x, y)
	End
End