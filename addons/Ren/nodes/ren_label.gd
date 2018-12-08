extends RichTextLabel

export(String, "ren", "bbcode") var mode = "ren"
export(String, MULTILINE) var ren_text = ""
export(Array, String) var vars_names = []

func _ready():
	mouse_filter = MOUSE_FILTER_STOP
	bbcode_enabled = true
	bbcode_text = Ren.text_passer(ren_text, mode)
	connect("meta_clicked", self, "on_meta_clicked")

	if vars_names == null:
		return
		
	for vn in vars_names:
		Ren.connect_var(vn, "value_changed", self, "on_value_changed")
	

func on_meta_clicked(meta):
	OS.shell_open(meta);

func on_value_changed(new_value):
	bbcode_text = Ren.text_passer(ren_text, mode)
