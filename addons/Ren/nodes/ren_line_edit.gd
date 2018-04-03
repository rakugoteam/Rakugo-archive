extends LineEdit

onready var rtl = RichTextLabel.new()
var input_placeholder = ""
var _type = ""

func _ready():
	Ren.connect("exec_statement", self, "_on_statement", [], CONNECT_PERSIST)
	add_child(rtl)
	hide()

func _unhandled_key_input(delta):
	if Input.is_key_pressed(KEY_ENTER):
		_on_exec(get_text())
		set_process_unhandled_key_input(false)

func _on_enter(text):
	var final_value = input_placeholder

	if text != "":
		final_value = get_text()

	set_process(false)
	Ren.exit_statement({"value":final_value})

func _on_statement(id, type, kwargs):
	_type = type
	if type != "input":
		if is_connected("text_entered", self , "_on_enter"):
			disconnect("text_entered", self , "_on_enter")

		set_process_unhandled_key_input(false)

		hide()
		return

	if "value" in kwargs:
		rtl.set_bbcode(kwargs.value)
		input_placeholder = rtl.get_text()
		set_placeholder(input_placeholder)

	show()
	grab_focus()
	set_process_unhandled_key_input(true)
	connect("text_entered", self , "_on_enter")