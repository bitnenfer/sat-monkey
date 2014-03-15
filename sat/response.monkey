Strict

Import sat.vector
Import sat.sat
Import sat.base

Class Response
	
	Field a:iBase = Null
	Field b:iBase = Null
	Field overlapN:Vector
	Field overlapV:Vector
	Field aInB:Bool
	Field bInA:Bool
	Field overlap:Float
	
	Method New ()
		overlapN = New Vector()
		overlapV = New Vector()
		Self.Clear()
	End
	
	Method Clear:Response ()
		Self.aInB = True
		Self.bInA = True
		Self.overlap = SAT.MAX_VALUE
		
		Return Self
	End
End