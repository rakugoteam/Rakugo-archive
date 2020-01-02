extends GridContainer
class_name RakugoMenu, "res://addons/Rakugo/icons/rakugo_menu_v.svg"

export var screen_size := Vector2(1024, 600)
export var ChoiceButton: PackedScene

var prev_visible := false

func _ready():
	Rakugo.connect("exec_statement", self, "_on_statement")
	Rakugo.connect("hide_ui", self, "_on_hide")


func _on_hide(value: bool) -> void:
	if value:
		get_parent().visible = prev_visible


func get_screen_xy(f:float, xy:String) -> float:
	var s := 0.0
	var c := 0.0
	
	match xy:
		"x":
			s = screen_size.x
			c = get_parent().rect_size.x

		"y":
			if f >= 0.5:
				s = -s
			
			s = screen_size.y
			c = get_parent().rect_size.y

	return s * f - c * 0.25


func _on_statement(type, parameters):
	if type != Rakugo.StatementType.MENU:
		get_parent().hide()

	prev_visible = get_parent().visible

	if type != Rakugo.StatementType.MENU:
		return

	var choices : Array = Rakugo.menu_node.choices_labels

	match parameters["mkind"]:
		"vertical":
			columns = 1

		"horizontal":
			columns = choices.size()

		"grid":
			columns = parameters["mcolumns"]
	
	get_parent().rect_position = Vector2.ZERO

	match parameters["manchor"]:
		"top_left":
			get_parent().set_anchors_preset(PRESET_TOP_RIGHT)

		"top_right":
			get_parent().set_anchors_preset(PRESET_TOP_RIGHT)

		"bottom_left":
			get_parent().set_anchors_preset(PRESET_BOTTOM_LEFT)

		"bottom_right":
			get_parent().set_anchors_preset(PRESET_BOTTOM_RIGHT)

		"center_left":
			get_parent().set_anchors_preset(PRESET_CENTER_LEFT)

		"center_top":
			get_parent().set_anchors_preset(PRESET_CENTER_TOP)

		"center_right":
			get_parent().set_anchors_preset(PRESET_CENTER_RIGHT)

		"center_bottom":
			get_parent().set_anchors_preset(PRESET_CENTER_BOTTOM)

		"center":
			get_parent().set_anchors_preset(PRESET_CENTER)

	get_parent().margin_bottom = get_screen_xy(get_parent().anchor_bottom, "y")
	get_parent().margin_top = get_screen_xy(get_parent().anchor_top, "y")
	get_parent().margin_left = get_screen_xy(get_parent().anchor_left, "x")
	get_parent().margin_right = get_screen_xy(get_parent().anchor_right, "x")

	for ch in get_children():
		ch.queue_free()

	var i = 0

	for ch in choices:
		var ch_button = ChoiceButton.instance()
		add_child(ch_button)
		ch_button.label.bbcode_text = "[center]" + ch + "[/center]"
		ch_button.id = i
		Rakugo.debug(["create button (", ch, ") with id: ", i])
		i += 1

	get_parent().show()


func _on_Hide_toggled(button_pressed):
	visible = !button_pressed
