Strict

Import sat.vector

Class VecStack Extends Stack<Vector>
	Method New ()
		Super.New()
	End
	
	Method New (data:Vector[])
		Super.New(data)
	End
	
	Method Wipe:VecStack ()
		Super.Clear()
		
		Return Self
	End
End