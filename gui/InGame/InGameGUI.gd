extends RakugoControl

func _on_show(id: String , state_value: Array, show_args: Dictionary) -> void:
	if not Rakugo.can_show_in_game_gui:
		return
	
	._on_show(id, state_value, show_args)

	# if _node_id != id:
	# 	return

	# rect_position = rnode.show_at(show_args, rect_position)

	# _set_state(state_value)

	# if not self.visible:
	# 	show()
