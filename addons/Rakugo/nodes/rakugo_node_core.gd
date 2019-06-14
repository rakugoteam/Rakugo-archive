extends Object
class_name RakugoNodeCore

signal on_substate(substate)

func is_procent(x : float) -> bool:
	return (x >= 0.0 and x <= 1.0)

func show_at(camera_postion : Vector2, show_args : Dictionary, def_pos:Vector2) -> Vector2:
	var x = camera_postion.x
	var y = camera_postion.y
	Rakugo.debug(["cam_pos", camera_postion])

	if show_args.empty():
		x = def_pos.x
		y = def_pos.y

	if "pos" in show_args:
		x = x + show_args.pos.x
		y = y + show_args.pos.y
		Rakugo.debug(["pos", show_args.pos])

	if "x" in show_args:
		x = x + show_args.x
		Rakugo.debug(["x", x])

	if "y" in show_args:
		y = y + show_args.y
		Rakugo.debug(["y", y])

	if is_procent(x) and x != 0:
		x = OS.window_size.x * x
		Rakugo.debug(["x%", x])

	if is_procent(y) and y != 0:
		y = OS.window_size.y * y
		Rakugo.debug(["y%", y])

	return Vector2(x, y)

func setup_state(state:Array) -> Array:
	if state == []:
		state = ["default"]

	for s in state:
		emit_signal("on_substate", s)

	return state
