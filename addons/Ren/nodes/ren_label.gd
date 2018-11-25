extends RichTextLabel

export(String, FILE, "*.txt") var ren_text_file = ""
export(String, MULTILINE) var ren_text = "" setget set_ren_text, get_ren_text
export(Array, String) var vars_names = []

func _ready():
	bbcode_enabled = true
	if not ren_text_file.empty():
		var file = File.new()
		file.open(ren_text_file, file.READ)
		ren_text = file.get_as_text()
		file.close()
	
	update_label()
	
	for vn in vars_names:
		Ren.connect_var(vn, "value_changed", self, "on_value_changed")
	
	connect("meta_clicked", self, "on_meta_clicked")

func update_label():
	bbcode_text = Ren.text_passer(ren_text)

func on_meta_clicked(meta):
	OS.shell_open(meta);

func on_value_changed(new_value):
	update_label()

func set_ren_text(value):
	ren_text = value
	update_label()

func get_ren_text():
	return ren_text
