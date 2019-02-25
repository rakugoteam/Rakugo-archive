extends LineEdit
class_name RenLineEdit

onready var rtl : = RichTextLabel.new()
var input_placeholder : = ""
var _type : int

func _ready() -> void:
	Ren.connect("exec_statement", self, "_on_statement")
	connect("visibility_changed", self, "_on_visibility_changed")
	add_child(rtl)
	hide()

func _unhandled_key_input(delta):
	if Input.is_key_pressed(KEY_ENTER):
		_on_enter(get_text())
		set_process_unhandled_key_input(false)

func _on_enter(text : String) -> void:
	var final_variable = input_placeholder

	if text != "":
		final_variable = get_text()

	set_process(false)
	Ren.exit_statement({"value":final_variable})

func _on_statement(type : int, parameters : Dictionary) -> void:
	_type = type
	if type != Ren.StatementType.ASK:
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
	connect("text_entered", self , "_on_enter")
	
func _on_visibility_changed():
	Ren.can_alphanumeric = !visible