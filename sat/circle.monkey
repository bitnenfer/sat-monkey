Strict

Import mojo
Import sat.vector
Import sat.base

Class Circle Implements iBase
	
	Field position:Vector
	Field radius:Float
	
	Method New (pos:Vector, radius:Float)
		Self.position = pos
		Self.radius = radius
	End
	
	Method DebugDraw:Void ()
		PushMatrix()
		Translate(position.x, position.y)
		DrawCircleStroke(0, 0, radius)
		PopMatrix()
	End
	
	#REM
		Author: Danilo (http://monkeycoder.co.nz/Account/showuser.php?id=1380)
		Source: http://monkeycoder.co.nz/Community/posts.php?topic=7909&post=78275
	#END
	Function DrawCircleStroke:Void(x:Int, y:Int, radius:Int)
	    Local temp_x:Int = 0
	    Local d:Int      = 3 - 2 * radius
	    
	    While temp_x <= radius
	        DrawRect(x+temp_x, y+radius, 1, 1) ' part 1
	        DrawRect(x-temp_x, y+radius, 1, 1)
	        DrawRect(x+radius, y+temp_x, 1, 1) ' part 2
	        DrawRect(x-radius, y+temp_x, 1, 1)
	        DrawRect(x+radius, y-temp_x, 1, 1) ' part 3
	        DrawRect(x-radius, y-temp_x, 1, 1)
	        DrawRect(x-temp_x, y-radius, 1, 1) ' part 4
	        DrawRect(x+temp_x, y-radius, 1, 1)
	        
	        If d < 0
	            d += 4 * temp_x + 6
	        Else
	            d += 4 * (temp_x - radius) + 10
	            radius -= 1
	        Endif
	        temp_x += 1
	    Wend
	End
End

