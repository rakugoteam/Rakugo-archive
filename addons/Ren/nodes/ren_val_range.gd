extends Range

export(String) var val_name = ""

func _ready():
	if val_name in Ren.values:
		value = Ren.get_value(val_name)

	Ren.connect("val_changed", self, "on_val_changed")

func on_val_changed(valn):
	if val_name != valn:
		return
		
	value = Ren.get_value(val_name)


