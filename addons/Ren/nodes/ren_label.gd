extends RichTextLabel

export(String, MULTILINE) var ren_text = ""
export(PoolStringArray) var variables = []

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	bbcode_enabled = true
	Ren.connect("var_changed", self, "on_var_changed")

func on_var_changed(var_name):
	if not(var_name in variables):
		return
		
	bbcode_text = Ren.text_passer(ren_text)
