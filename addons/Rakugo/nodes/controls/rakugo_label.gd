tool
extends RichTextLabel
class_name RakugoTextLabel, "res://addons/Rakugo/icons/rakugo_text_label.svg"

export(String, "renpy", "bbcode") var mode := "renpy"
export(String, MULTILINE) var rakugo_text := "" setget _set_rakugo_text, _get_rakugo_text
export(String, FILE, "*.txt") var rakugo_text_file := "" setget _set_rakugo_file, _get_rakugo_file
export(Array, String) var vars_names := []

var _rakugo_text := ""
var _rakugo_text_file := ""

var file := File.new()

func _ready() -> void:
	bbcode_enabled = true
	_set_rakugo_file(rakugo_text_file)
	update_label()

	for vn in vars_names:
		Rakugo.connect_var(vn, "value_changed", self, "on_value_changed")

	connect("meta_clicked", self, "on_meta_clicked")
	connect("visibility_changed", self, "on_visibility_changed")


func update_label() -> void:
	bbcode_enabled = true
	
	if Engine.editor_hint:
		bbcode_text = TextPasser.text_passer(_rakugo_text, {}, mode)
	else:
		bbcode_text = Rakugo.text_passer(_rakugo_text, mode)


func on_meta_clicked(meta) -> void:
	OS.shell_open(meta)


func on_value_changed(var_name: String, new_value) -> void:
	if var_name in vars_names:
		update_label()


func _set_rakugo_file(value: String) -> void:
	_rakugo_text_file = value
	if value.empty():
		return

	if not file.file_exists(value):
		return

	file.open(value, file.READ)
	_set_rakugo_file(file.get_as_text())
	file.close()


func _get_rakugo_file() -> String:
	return _rakugo_text_file


func _set_rakugo_text(value:String) -> void:
	_rakugo_text = value
	update_label()


func _get_rakugo_text() -> String:
	return _rakugo_text


func on_visibility_changed() -> void:
	if not visible:
		return

	update_label()
