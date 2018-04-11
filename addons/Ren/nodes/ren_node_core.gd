extends Object

func is_procent(x):
	return (typeof(x) == TYPE_REAL
			and x >= 0.0
			and x <= 1.0)

func show_at(camera_postion, position, show_args):
	var x = position.x
	var y = position.y

	if "pos" in show_args:
		x = show_args.pos.x
		y = show_args.pos.y

	if "x" in show_args:
		x = show_args.x

	if "y" in show_args:
		y = show_args.y
	
	if is_procent(x) and x != 0:
		x = camera_postion.x + OS.window_size.x * x
		
		
	if is_procent(y) and y != 0:
		y = camera_postion.y + OS.window_size.y * y
		
	
	var pos = Vector2(x, y)
	
	return pos


