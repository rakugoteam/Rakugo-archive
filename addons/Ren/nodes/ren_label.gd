extends RichTextLabel

export(String, MULTILINE) var ren_text = ""
export(Array, String) var vars_names = [] 

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	bbcode_enabled = true
	update()
	for vn in vars_names:
		Ren.connect_var(vn, "value_changed", self, "on_value_changed")

func on_value_changed(new_value):
	bbcode_text = Ren.text_passer(ren_text)
