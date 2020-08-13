extends Object
class_name RakugoNodeCore

signal on_substate(substate)

func is_procent(x: float) -> bool:
	return (x >= 0.0 and x <= 1.0)


func show_at(show_args: Dictionary, def_pos:Vector2) -> Vector2:

	var x = 0
	var y = 0

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

func make_saveable(node:Node, value:bool):
	if value:
		node.add_to_group("save", true)

	elif node.is_in_group("save"):
		node.remove_from_group("save")

	if Engine.editor_hint:
		return

	if node.is_in_group("save"):
		Rakugo.debug([node.name, "added to save"])


func save_error_node(node_link:NodeLink, node_id:String) -> bool:
	if not node_link:
		push_error("error with saving: %s" %node_id)
		return true

	return false


func save_visible_node(node_link:NodeLink, node: Node):
	if save_error_node(node_link, node.node_id):
		return

	node_link.value["visible"] = node.visible
	node_link.value["state"] = node.state
	node_link.value["show_args"] = node.last_show_args


func load_error_node(node_link:NodeLink, node_id:String) -> bool:
	if not node_link:
		push_error("error with loading: %s"  %node_id)
		return true

	return false


func load_visible_node(node_link:NodeLink, node: Node):
	if load_error_node(node_link, node.node_id):
		return

	if "visible" in node_link.value:
		node.visible = node_link.value["visible"]

	if node.visible:

		if "state" in node_link.value:
			node.state = node_link.value["state"]

		if "show_args" in node_link.value:
			node.last_show_args = node_link.value["show_args"]

		node._on_show(node.node_id, node.state, node.last_show_args)

	else:
		node._on_hide(node.node_id)
