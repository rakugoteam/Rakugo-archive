extends Object

func is_procent(x):
	return (x >= 0.0 and x <= 1.0)

func show_at(camera_postion, show_args):
	var x = camera_postion.x
	var y = camera_postion.y
	# print("cam_pos ", camera_postion)

	if "pos" in show_args:
		x = x + show_args.pos.x
		y = y + show_args.pos.y
		# print("pos ", show_args.pos)

	if "x" in show_args:
		x = x + show_args.x
		# print("x ", x)

	if "y" in show_args:
		y = y + show_args.y
		# print("y ", y)
	
	if is_procent(x) and x != 0:
		x = OS.window_size.x * x
		# print("x% ", x)
		
	if is_procent(y) and y != 0:
		y = OS.window_size.y * y
		# print("y% ", y)
	
	return Vector2(x, y)


