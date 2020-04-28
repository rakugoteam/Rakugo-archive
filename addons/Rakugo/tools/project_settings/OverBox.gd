tool
extends HBoxContainer

var rps : RakugoProjectSettings

func _ready() -> void:
	$TextureRect.texture = get_icon("ScriptExtend", "EditorIcons")
	$Button.icon = get_icon("ScriptExtend", "EditorIcons")
	$Button.connect("pressed", $FileDialog, "popup_centered")
	$FileDialog.connect("confirmed", self, "_on_fd")
	$Reload.icon = get_icon("Reload", "EditorIcons")
	$Reload.connect("pressed", self, "_on_reload")
	$CheckButton.connect("pressed", self, "_on_toggled")


func _on_toggled() -> void:
	$Button.disabled = ! $Button.disabled
	$Button.text = ""


func _on_reload() -> void:
	load_setting()


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


func _on_fd():
	$Button.text = $FileDialog.current_path
	rps.load_cfg($Button.text)
	_on_reload()
