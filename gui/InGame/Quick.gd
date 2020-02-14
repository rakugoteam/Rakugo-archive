extends HBoxContainer

onready var Screens := get_node("../../Screens")

func _ready() -> void:
	$Quit.connect("pressed", Screens, "_on_Quit_pressed")
	$Options.connect("pressed", Screens, "_on_Options_pressed")
	$Hide.connect("toggled", self, "_on_Hide_toggled")
	

func _hide_on_input(event):
	if event.is_action_pressed("ui_select"):
		$Hide.pressed = !$Hide.pressed
		_on_Hide_toggled($Hide.pressed)


func _on_Hide_toggled(value: bool) -> void:
	Rakugo.emit_signal("hide_ui", !value)


func _input(event: InputEvent) -> void:
	if Rakugo.can_alphanumeric:
		_hide_on_input(event)
