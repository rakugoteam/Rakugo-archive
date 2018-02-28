## This is in-game gui example for Ren API ##
## version: 0.5.0 ##
## License MIT ##

extends VBoxContainer

onready var ren	= get_node("/root/Window")

# onready var $InputLine = $Input
# onready var $BBCode = $$BBCode # use to parse $BBCode for $InputLine
onready var timer = get_node("../Timer")
var input_placeholder = ""
var _type = ""


func _ready():
	ren.connect("enter_statement", self, "_on_statement")
	$InputLine.hide()
	timer.connect("timeout", self, "_on_timeout")

func _on_timeout():
	set_process_unhandled_key_input(_type == "input")

func _unhandled_key_input(delta):
	if Input.is_key_pressed(KEY_ENTER):
		_on_enter($InputLine.get_text())


func _on_enter(text):
	var final_value = input_placeholder

	if text != "":
		final_value = $InputLine.get_text()
	
	set_process(false)
	ren.emit_signal("exit_statement", {"value":final_value})


func _on_statement(type, kwargs):
	_type = type
	if type != "input":
		if $InputLine.is_connected("text_entered", self , "_on_enter"):
			$InputLine.disconnect("text_entered", self , "_on_enter")

		$InputLine.hide()
		return

	if "value" in kwargs:
		$BBCode.set_bbcode(kwargs.value)
		input_placeholder = $BBCode.get_text()
		$InputLine.set_placeholder(input_placeholder)
	
	$InputLine.show()
	$InputLine.grab_focus()
	$InputLine.connect("text_entered", self , "_on_enter")