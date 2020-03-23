tool
extends Node

onready var grid := $ScrollContainer/GridContainer
onready var tween := $Label/Tween
var file := File.new()

func _ready():
	for e in $Emojis.emojis_dict.keys():
		var png = $Emojis.get_path_to_emoji(e, 36)
		if not file.file_exists(png):
			continue
			
		var b := Button.new()
		b.name = e
		b.icon = load(png)
		b.connect("pressed", self, "on_button", [b])
		grid.add_child(b)
	
	$LineEdit.connect("text_changed", self, "on_text_changed")
	tween.connect("tween_all_completed", $Label, "hide")


func notify(text:String) -> void:
	$Label.text = text
	var scolor = Color(0, 0, 0, 0)
	tween.interpolate_property(
		$Label, "modulate", scolor, Color.green, 
		1, Tween.TRANS_LINEAR,Tween.EASE_IN)
		
	tween.interpolate_property(
		$Label, "modulate", Color.green, scolor,
		1, Tween.TRANS_LINEAR,Tween.EASE_IN, 0.7)
		
	$Label.show()
	tween.start()


func on_button(button: Button):
	var text = '"' + button.name + '"' + "copied to clipboard" 
	notify(text)
	OS.clipboard = button.name


func on_text_changed(text: String):
	if text == "":
		for ch in grid.get_children():
			ch.visible = true
		
		return
	
	for ch in grid.get_children():
			ch.visible = false
			if ch.name.find(text) != -1:
				ch.visible = true
