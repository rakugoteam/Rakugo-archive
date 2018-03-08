extends Label

export(String) var val_name = "version"
var _val_name = ""

func set_val_name(value):
	_val_name = value
	text = val_name

func get_val_name():
	return _val_name

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	text = Ren.get_value(val_name)
	Ren.connect("on_val_changed", self, "update")

func update(valn):
	if val_name == valn:
		text = Ren.get_value(val_name)
