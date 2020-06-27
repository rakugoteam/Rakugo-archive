tool
extends HBoxContainer

var rps : RakugoProjectSettings

func _ready() -> void:
	$TextureRect.texture = get_icon("ScriptExtend", "EditorIcons")

	$Button.icon = get_icon("ScriptExtend", "EditorIcons")
	$Button.connect("pressed", self, "on_load_file")

	$FileDialog.connect("confirmed", self, "_on_fd")

	$New.icon = get_icon("ScriptCreate", "EditorIcons")
	$New.connect("pressed", self, "on_new_file")

	$Reload.icon = get_icon("Reload", "EditorIcons")
	$Reload.connect("pressed", self, "_on_reload")

	$CheckButton.connect("pressed", self, "_on_toggled")


func _on_toggled() -> void:
	$Button.disabled = ! $Button.disabled
	$Button.text = ""


func _on_reload() -> void:
	load_setting()


func on_load_file() -> void:
	$FileDialog.mode = FileDialog.MODE_OPEN_FILE
	$FileDialog.window_title = "Load *.cfg File"
	$FileDialog.popup_centered()


func on_new_file() -> void:
	$FileDialog.mode = FileDialog.MODE_SAVE_FILE
	$FileDialog.window_title = "Where to Save new *.cfg File"
	$FileDialog.popup_centered()


func load_other_setting() -> void:
	for ch in get_parent().get_children():
		if ch != self and ch.name != "Label":
			ch.load_setting()


func load_setting() -> void:
	if $Button.text:
		$CheckButton.pressed = true
		rps.load_cfg($Button.text)

	load_other_setting()
	

func save_setting() -> void:

	for ch in get_parent().get_children():
		if ch != self and ch.name != "Label":
			ch.save_setting()

	if $CheckButton.pressed and rps.cfg_loaded:
		rps.save_cfg($Button.text)


func _on_fd() -> void:
	$Button.text = $FileDialog.current_path

	if $FileDialog.mode == FileDialog.MODE_SAVE_FILE:
		rps.cfg_path = $FileDialog.current_path

	else:
		rps.load_cfg($Button.text)
		_on_reload()
