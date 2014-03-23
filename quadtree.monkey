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

Class QuadTree
	
	Private
	
	Field depth:Int
	Field maxDepth:Int
	Field maxChildren:Int
	Field children:Stack<iSAT>
	Field nodes:QuadTree[4]
	Field hwidth:Float
	Field hheight:Float
	Field indexes:Int[4]
	Field x:Float
	Field y:Float
	Field width:Float
	Field height:Float
	Field returnObjects:Stack<iSAT>
	Field root:QuadTree
	Field rWidth:Float
	Field rHeight:Float
	
	' Caching
	Field b:Box
	Field bx:Float
	Field by:Float
	Field bw:Float
	Field bh:Float
	Field i:Int
	Field len:Int
	
	Public
	
	Const TOP_LEFT:Int = 0
	Const TOP_RIGHT:Int = 1
	Const BOTTOM_LEFT:Int = 2
	Const BOTTOM_RIGHT:Int = 3
	Const NONE:Int = -1
	
	Method New (x:Float, y:Float, w:Float, h:Float, depth:Int = 0, maxDepth:Int = 4, maxChildren:Int = 4, root:QuadTree = Null)
		Self.depth = depth
		Self.maxDepth = 4
		Self.maxChildren = maxChildren
		Self.hwidth = w / 2
		Self.hheight = h / 2
		Self.children = New Stack<iSAT>()
		Self.indexes = [-1, -1, -1, -1]
		Self.x = x
		Self.y = y
		Self.width = w
		Self.height = h
		If (depth = 0)
			Self.root = Self
		Else
			Self.root = root
		Endif
		rWidth = Self.root.x + Self.root.width
		rHeight = Self.root.y + Self.root.height
		returnObjects = New Stack<iSAT>()
	End
	
	Method Split:Void ()
		Local depth:Int = Self.depth + 1
		nodes[0] = New QuadTree(x, y, hwidth, hheight, depth, maxDepth, maxChildren, root)
		nodes[1] = New QuadTree(x + hwidth, y, hwidth, hheight, depth, maxDepth, maxChildren, root)
		nodes[2] = New QuadTree(x, y + hheight, hwidth, hheight, depth, maxDepth, maxChildren, root)
		nodes[3] = New QuadTree(x + hwidth, y + hheight, hwidth, hheight, depth, maxDepth, maxChildren, root)
	End
	
	Method GetNodes:QuadTree[] ()
		Return nodes
	End
	
	Method GetIndexes:Int[] (base:iSAT)
		b = base.GetBounds()
		bx = b.position.x
		by = b.position.y
		bw = bx + b.width
		bh = by + b.height
		i = 0
		len = nodes.Length() - 1
		
		indexes = [-1, -1, -1, -1]
		
		If (bx > rWidth Or
			bw < root.x Or
			by > rHeight Or
			bh < root.y)
				Return [-1]
		Endif
		
		If (bx <= x + hwidth)
			If (by <= y + hheight)
				For i = 0 To len
					If (indexes[i] = -1)
						indexes[i] = TOP_LEFT
						Exit
					Endif
				Next
				If (bw >= x + hwidth)
					For i = 0 To len
						If (indexes[i] = -1)
							indexes[i] = TOP_RIGHT
							Exit
						Endif
					Next
				Endif
			Endif
			If (bh >= y + hheight)
				For i = 0 To len
					If (indexes[i] = -1)
						indexes[i] = BOTTOM_LEFT
						Exit
					Endif
				Next
				If (bw >= x + hwidth)
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
				If (bh > y + hheight)
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
	
	Method Insert:Void (base:iSAT)
		Local i:Int
		Local len:Int
		indexes = GetIndexes(base)
		If (nodes[0] <> Null)
			len = indexes.Length() - 1
			For i = 0 To len
				If (indexes[i] <> -1) 
					nodes[indexes[i]].Insert(base)
				Endif
			Next
		Elseif (indexes[0] <> -1)
			children.Push(base)
			If (children.Length() > maxChildren And depth < maxDepth)
				Split()
				len = children.Length() - 1
				For i = 0 To len
					Insert(children.Get(i))
				Next
				children.Clear()
			Endif		
		Endif
	End 
	
	Method Length:Int ()
		Return children.Length()
	End
	
	Method Retrieve:Stack<iSAT> (base:iSAT)
		returnObjects.Clear()
		indexes = GetIndexes(base)
		If (nodes[0] <> Null)
			len = indexes.Length() - 1
			For i = 0 To len
				If (indexes[i] <> -1) 
					returnObjects.Push(nodes[indexes[i]].Retrieve(base).ToArray())
				EndIf
			Next
		Else
			If (indexes[0] <> -1)
				returnObjects.Push(children.ToArray())
			Endif
		Endif
		Return returnObjects
	End
	
	Method Clear:Void ()
		len = nodes.Length() - 1
		For i = 0 To len
			If (nodes[i] <> Null)
				nodes[i].Clear()
				nodes[i] = Null
			Endif
		Next
		Self.children.Clear()
	End
	
	Method SetBounds:Void (x:Float, y:Float, width:Float, height:Float)
		Self.x = x
		Self.y = y
		Self.width = width
		Self.height = height
		Self.hwidth = width / 2
		Self.hheight = height / 2
		Self.rWidth = Self.root.x + Self.root.width
		Self.rHeight = Self.root.y + Self.root.height
	End
	
	Method DebugDraw:Void ()
		len = nodes.Length() - 1
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