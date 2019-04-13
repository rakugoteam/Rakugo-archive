tool
extends HBoxContainer

signal request_refresh_plugin(p_name)

onready var options = $OptionButton

func _ready():
	reload_items()

func reload_items():
	if not options:
		return
	var dir = Directory.new()
	dir.change_dir("res://addons/")
	dir.list_dir_begin(true, true)
	var file = dir.get_next()
	options.clear()
	while file:
		if dir.dir_exists("res://addons/" + file) and file != "godot-plugin-refresher":
			options.add_item(file)
		file = dir.get_next()

func _on_RefreshButton_pressed():
	var plugin = options.get_item_text(options.selected)
	if not plugin:
		return
	emit_signal("request_refresh_plugin", plugin)