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
	notify("Loaded");


func save() -> void:
	over_box.save_setting()


func notify(text:String) -> void:
	$VBoxContainer/Label.text = text
	var scolor = Color(0, 0, 0, 0)
	$VBoxContainer/Label.show()

	$Tween.interpolate_property(
		$VBoxContainer/Label, "modulate",
		scolor, Color.green,
		1, Tween.TRANS_LINEAR,Tween.EASE_IN)

	$Tween.interpolate_property(
		$VBoxContainer/Label, "modulate",
		Color.green, scolor,
		1, Tween.TRANS_LINEAR,Tween.EASE_IN, 0.7)

	$Tween.start()
