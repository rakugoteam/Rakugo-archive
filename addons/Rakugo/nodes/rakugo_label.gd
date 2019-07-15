extends RichTextLabel
class_name RakugoTextLabel

export(String, "renpy", "bbcode") var mode := "renpy"
export(String, FILE, "*.txt") var rakugo_text_file := ""
export(String, MULTILINE) var rakugo_text := ""
export(Array, String) var vars_names := []

var file := File.new()

func _ready() -> void:
	bbcode_enabled = true
	set_rakugo_file(rakugo_text_file)
	update_label()
	
	for vn in vars_names:
		Rakugo.connect_var(vn, "value_changed", self, "on_value_changed")
	
	connect("meta_clicked", self, "on_meta_clicked")
	connect("visibility_changed", self, "on_visibility_changed")


func update_label() -> void:
	bbcode_text = Rakugo.text_passer(rakugo_text, mode)


func on_meta_clicked(meta) -> void:
	OS.shell_open(meta)


func on_value_changed(var_name: String, new_value) -> void:
	if var_name in vars_names:
		update_label()


func set_rakugo_file(value: String) -> void:
	if value.empty():
		return
	
	file.open(value, file.READ)
	rakugo_text = file.get_as_text()
	file.close()
	update_label()


func on_visibility_changed() -> void:
	if visible == false:
		return
	
	update_label()
