extends RichTextLabel

export(String, MULTILINE) var ren_text = ""
export(Array, String) var vars_names = [] 

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	bbcode_enabled = true
	update()
	for vn in vars_names:
		Ren.connect_var(vn, "var_changed", self, "on_var_changed")

func on_var_changed(var_name):
	bbcode_text = Ren.text_passer(ren_text)
