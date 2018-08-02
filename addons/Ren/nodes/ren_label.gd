extends RichTextLabel

export(String, MULTILINE) var ren_text = ""

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	bbcode_enabled = true
	update()
	Ren.connect("var_changed", self, "on_var_changed")

func on_var_changed(var_name):
	bbcode_text = Ren.text_passer(ren_text)
