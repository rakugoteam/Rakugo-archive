extends HBoxContainer

export onready var text_speed_slider: Slider = get_node("../TextSpeedBox/Slider")

func _ready() -> void:
	$CheckButton.connect("toggled", self, "_on_toggled")
	connect("visibility_changed", self, "on_visibility_changed")


func _on_toggled(value):
	text_speed_slider.editable = value	


func on_visibility_changed() -> void:
	if visible == false:
		return
		
	_on_toggled(Rakugo.get_value("typing_text"))
	