extends ScrollContainer


func scroll_to_bottom():
	var scrollbar = get_v_scrollbar()
	scrollbar.value = scrollbar.max_value
