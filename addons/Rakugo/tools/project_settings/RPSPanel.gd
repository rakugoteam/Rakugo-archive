tool
extends Panel

func _ready() -> void:
	$Label.hide()
	$VBoxContainer/SaveButton.icon = get_icon("Save", "EditorIcons")
	$VBoxContainer/SaveButton.connect("pressed", self, "_on_ok")
	connect("visibility_changed", self, "_on_visibility_changed")
	load_settings()


func get_boxes() -> Node:
	return $VBoxContainer/ScrollContainer/VBoxContainer


func _on_visibility_changed():
	if visible:
		load_settings()
		
	else:
		_on_ok()


func load_settings() -> void:
	get_boxes().get_node("OverBox").load_setting()
	notify("Loaded");


func _on_ok() -> void:
	get_boxes().get_node("OverBox").save_setting()
#	notify("Saved")


func notify(text:String) -> void:
	$Label.text = text
	var scolor = Color(0, 0, 0, 0)
	$Tween.interpolate_property(
		$Label, "modulate", scolor, Color.green,
		1, Tween.TRANS_LINEAR,Tween.EASE_IN)

	$Tween.interpolate_property(
		$Label, "modulate", Color.green, scolor,
		1, Tween.TRANS_LINEAR,Tween.EASE_IN, 0.7)

	$Label.show()
	$Tween.start()
