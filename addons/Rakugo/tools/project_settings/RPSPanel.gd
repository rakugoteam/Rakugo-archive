tool
extends Panel

onready var rps : RakugoProjectSettings = $RakugoProjectSettings
onready var over_box = $VBoxContainer/OverBox

func _ready() -> void:
	$VBoxContainer/Label.hide()

	for box in $VBoxContainer.get_children():
		if box.name != "Label":
			box.rps = rps


func connect_to_parten() -> void:
	var project_settings_window = get_parent().get_parent()
	project_settings_window.connect("about_to_show", self, "load_settings")
	project_settings_window.connect("confirmed", self, "save")


func load_settings() -> void:
	rps.load_cfg()
	over_box.get_node("Button").text = rps.cfg_path
	over_box.load_other_setting()
	$VBoxContainer/Label.notify();


func save() -> void:
	over_box.save_setting()
