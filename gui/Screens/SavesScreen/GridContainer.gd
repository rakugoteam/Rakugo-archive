extends GridContainer


func set_child_min_size(child):
	child.rect_min_size.y = (get_parent().rect_size.y - self.get("custom_constants/vseparation")) / 2

func _on_add_save_slot(save_slot):
	add_child(save_slot)
	set_child_min_size(save_slot)


func _on_clear_save_slots():
	for c in get_children():
		remove_child(c)
		c.queue_free()
