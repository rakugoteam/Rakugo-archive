extends AcceptDialog

signal return_output(confirm_action)

var output = false
onready var negative_button:Button = self.add_cancel("No")

func _ready():
	self.register_text_enter($LineEdit)

func delete_confirm():
	output = false
	$LineEdit.visible = false
	self.dialog_text = "Are you sure you want to delete this save?"
	self.get_ok().text = "Yes"
	negative_button.text = "No"
	self.popup_centered()

func overwrite_confirm(keep_both:bool = false):
	output = false
	$LineEdit.visible = false
	self.dialog_text = "Are you sure you want to overwrite your save?"
	if keep_both:
		self.get_ok().text = "Overwrite"
		negative_button.text = "Keep Both"
	else:
		self.get_ok().text = "Yes"
		negative_button.text = "No"
	self.popup_centered()

func name_save_confirm(placeholder = null):
	output = false
	$LineEdit.visible = true
	if placeholder:
		$LineEdit.placeholder_text = placeholder
	self.dialog_text = "What do you want to name your save?\n"#This is a trick to make the Dialog bigger and place the LineEdit over the buttons
	self.get_ok().text = "Save"
	negative_button.text = "Cancel"
	self.popup_centered()
	self.dialog_text = "What do you want to name your save?"#This is a trick to make the Dialog bigger and place the LineEdit over the buttons
	$LineEdit.grab_focus()


func _on_confirmed():
	if $LineEdit.visible:
		output = $LineEdit.text
	else:
		output = true
	hide()

func _on_popup_hide():
	emit_signal("return_output", output)
