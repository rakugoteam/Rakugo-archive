extends RichTextLabel

export(String, MULTILINE) var ren_text = ""

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	bbcode_enabled = true
	update()
	Ren.connect("val_changed", self, "on_val_changed")

func on_val_changed(val_name):
	bbcode_text = Ren.text_passer(ren_text)
