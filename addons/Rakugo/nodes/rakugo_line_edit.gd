extends LineEdit
class_name RakugoLineEdit

onready var rtl : = RichTextLabel.new()
var input_placeholder : = ""
var _type : int
var _active : = true
var active : bool setget _set_active, _get_active

func _ready() -> void:
	_set_active(true)
	add_child(rtl)
	hide()

func _unhandled_key_input(delta):
	if Input.is_key_pressed(KEY_ENTER):
		enter()

func enter() -> void:
	_on_enter(get_text())
	set_process_unhandled_key_input(false)

func _on_enter(text : String) -> void:
	var final_variable = input_placeholder

	if text != "":
		final_variable = get_text()

	set_process(false)
	Rakugo.exit_statement({"value":final_variable})

func _on_statement(type : int, parameters : Dictionary) -> void:
	_type = type
	if type != Rakugo.StatementType.ASK:
		if is_connected("text_entered", self , "_on_enter"):
			disconnect("text_entered", self , "_on_enter")

		set_process_unhandled_key_input(false)

		hide()
		return

	if "value" in parameters:
		rtl.set_bbcode(parameters.value)
		input_placeholder = rtl.get_text()
		set_placeholder(input_placeholder)

	show()
	grab_focus()
	set_process_unhandled_key_input(true)
	
	if not is_connected("text_entered", self , "_on_enter"):
		connect("text_entered", self , "_on_enter")
	
func _on_visibility_changed():
	Rakugo.can_alphanumeric = !visible
	
func _set_active(value:bool) -> void:
	_active = value
	
	if value:
		if not Rakugo.is_connected("exec_statement", self, "_on_statement"):
			Rakugo.connect("exec_statement", self, "_on_statement")
		
		if not is_connected("visibility_changed", self, "_on_visibility_changed"):
			connect("visibility_changed", self, "_on_visibility_changed")
	
	else:
		if Rakugo.is_connected("exec_statement", self, "_on_statement"):
			Rakugo.disconnect("exec_statement", self, "_on_statement")
		
		if is_connected("visibility_changed", self, "_on_visibility_changed"):
			disconnect("visibility_changed", self, "_on_visibility_changed")
		
func _get_active() -> bool:
	return _active