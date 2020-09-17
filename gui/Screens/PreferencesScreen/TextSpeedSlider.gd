extends Slider

func _on_value_changed(value):
	Rakugo.set_var("text_time", abs(value))

func _on_visibility_changed():
	if visible:
		value = -Rakugo.get_value("text_time")
