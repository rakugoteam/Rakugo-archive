extends GridContainer

var child_min_y_size = -1

func set_child_min_size(child):
	if child_min_y_size == -1:
		child_min_y_size = (get_parent().rect_size.y - self.get("custom_constants/vseparation")) / 2
	child.rect_min_size.y = child_min_y_size

func _on_add_save_slot(save_slot):
	add_child(save_slot)
	set_child_min_size(save_slot)


func _on_clear_save_slots():
	for c in get_children():
		remove_child(c)
		c.queue_free()
