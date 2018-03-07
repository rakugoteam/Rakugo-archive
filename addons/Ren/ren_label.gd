extends RichTextLabel

export(String, MULTILINE) var ren_text = "{center}[version]{/center}"

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	bbcode_enabled = true
	update()
	Ren.connect("on_val_changed", self, "update")

func update(val_name):
	bbcode_text = Ren.text_passer(ren_text)
