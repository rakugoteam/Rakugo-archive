extends ScrollContainer

signal scroll(scroll_value)

func _ready():
	get_v_scrollbar().connect("scrolling", self, "_on_scroll")

func _on_scroll():
	Settings.set('rakugo/saves/current_scroll_value', self.scroll_vertical, false)

func _on_visibility_changed():
	self.scroll_vertical = Settings.get('rakugo/saves/current_scroll_value', 0)
