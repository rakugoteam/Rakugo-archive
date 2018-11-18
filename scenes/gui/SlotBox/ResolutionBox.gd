extends "CollapsedList.gd"

var resolution = Vector2()

func _ready():
	connect("visibility_changed", self, "_on_visibility_changed")
	## taken from https://freegamedev.net/wiki/Screen_Resolutions
	options_list = [
		Vector2(640, 480),
		Vector2(800, 480),
		Vector2(1024, 600),
		Vector2(1024, 768),
		Vector2(1200, 900),
		Vector2(1280, 720),
		Vector2(1280, 1024),
		Vector2(1366, 768),
		Vector2(1440, 900),
		Vector2(1680, 1050),
		Vector2(1600, 1200),
		Vector2(1920, 1080),
		Vector2(2560, 1440),
		Vector2(2560, 1600)
	]

func _on_visibility_changed():
	update_label(OS.window_size)

func update_label(size = options_list[current_choice_id]):
	$Label.text = str(size.x) + "x" + str(size.y)
	if not (size in options_list):
		options_list.append(size)
	resolution = size
