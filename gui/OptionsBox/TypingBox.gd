extends HBoxContainer

export onready var text_speed_slider : Slider = get_node("../TextSpeedBox/Slider")

func _ready() -> void:
	$CheckButton.connect("toggled", self, "_on_toggled")

func _on_toggled(value):
	text_speed_slider.editable = value	


