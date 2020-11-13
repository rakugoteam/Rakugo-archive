extends Node2D

onready var SceneAnchor := $Panel/SceneAnchor
onready var Screens := $Panel/TabContainer/Screens
onready var InGameGUI := $Panel/TabContainer/InGameGUI
onready var Loading := $Panel/TabContainer/Loading
onready var QuitScreen := $Panel/QuitScreen

func _ready():
	Rakugo.current_scene_node = self
	
	OS.window_fullscreen = Settings.get("display/window/size/fullscreen")
	OS.window_maximized = Settings.get("display/window/size/maximized", false)
	if not OS.window_fullscreen and not OS.window_maximized:
		init_window_size()
		center_window()
	
	get_tree().get_root().connect("size_changed", self, "_on_window_resized")


func init_window_size():
	if Settings.get("display/window/size/height") == 0:
		Settings.set("display/window/size/height", Settings.get("display/window/size/height", null, false, true))
	if Settings.get("display/window/size/width") == 0:
		Settings.set("display/window/size//width", Settings.get("display/window/size/width", null, false, true))
	var current_ratio = (1.0 * Settings.get("display/window/size/width")) / Settings.get("display/window/size/height")
	var default_ratio = (1.0 * Settings.get("display/window/size/width", null, false, true)) / Settings.get("display/window/size/height", null, false, true)
	if current_ratio < default_ratio:
		Settings.set("display/window/size/height", int(Settings.get("display/window/size/width") / default_ratio))
	elif current_ratio > default_ratio:
		Settings.set("display/window/size/width", int(default_ratio * Settings.get("display/window/size/height")))
	OS.window_size.x = Settings.get("display/window/size/width")
	OS.window_size.y = Settings.get("display/window/size/height")


func center_window():
	OS.window_position = (OS.get_screen_size(OS.current_screen) - OS.window_size) * 0.5

func _on_window_resized():
	Settings.set("display/window/size/fullscreen", OS.window_fullscreen)
	Settings.set("display/window/size/maximized", OS.window_maximized)
	if not OS.window_fullscreen and not OS.window_maximized:
		Settings.set("display/window/size/width", OS.window_size.x)
		Settings.set("display/window/size/height", OS.window_size.y)

func select_ui_tab(tab:int):
	$Panel/TabContainer.current_tab = tab

func get_current_ui():
	return $Panel/TabContainer.get_current_tab_control()
