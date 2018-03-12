extends Label

export(String) var val_name = "version"

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	text = str(Ren.get_value(val_name))
	Ren.connect("on_val_changed", self, "update")

func update(valn):
	if val_name == valn:
		text = str(Ren.get_value(val_name))
