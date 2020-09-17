extends ScrollContainer

signal scroll(scroll_value)

func _ready():
	get_v_scrollbar().connect("scrolling", self, "_on_scroll")

func _on_scroll():
	print(self.scroll_vertical)
	settings.saves_scroll = self.scroll_vertical

func _on_visibility_changed():
	self.scroll_vertical = settings.saves_scroll
