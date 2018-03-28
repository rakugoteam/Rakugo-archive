extends Button

export(Color) var idle_text_color = Color( 0.533333, 0.533333, 0.533333, 1 )
export(Color) var focus_text_color = Color( 0, 0.506836, 0.675781, 1 )
export(Color) var hover_text_color = Color( 0.877647, 0.882353, 0.887059, 1 )
export(Color) var pressed_text_color = Color( 0, 0.6, 0.8, 1 )
export(Color) var disable_text_color = Color( 0.533333, 0.533333, 0.498039, 0.533333 )

onready var label = RichTextLabel.new()
var id = -1

func _ready():
	connect("focus_entered", self, "_on_focus")
	connect("focus_exited", self, "_on_idle")
	connect("mouse_entered", self, "_on_hover")
	connect("mouse_exited", self, "_on_idle")
	connect("pressed", self, "_on_pressed")
	connect("resized", self, "_on_resized")
	label.mouse_filter =  MOUSE_FILTER_IGNORE
	label.bbcode_enabled = true
	add_child(label)

func _on_resized():
	label.rect_size = rect_size

func _on_idle():
	label.add_color_override("default_color", idle_text_color)

func _on_focus():
	label.add_color_override("default_color", focus_text_color)

func _on_hover():
	label.add_color_override("default_color", hover_text_color)

func _on_pressed():
	label.add_color_override("default_color", pressed_text_color)
	print("final_choice ", id)
	Ren.set_meta("last_choice",id) #for checking choice in VS
	Ren.enter_block({"final_choice":id})

	print(Ren.name)

func set_disabled(value):
	.set_disabled(value)
	if value:
		label.add_color_override("default_color", disable_text_color)
	else:
		_on_idle()
