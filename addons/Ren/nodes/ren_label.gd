extends RichTextLabel

export(String, MULTILINE) var ren_text = ""
export(Array, String) var vars_names = [] 

func _ready():
	bbcode_enabled = true
	bbcode_text = Ren.text_passer(ren_text)
	for vn in vars_names:
		Ren.connect_var(vn, "value_changed", self, "on_value_changed")
	
	connect("meta_clicked", self, "on_meta_clicked")

func on_meta_clicked(meta):
	OS.shell_open(meta);

func on_value_changed(new_value):
	bbcode_text = Ren.text_passer(ren_text)
