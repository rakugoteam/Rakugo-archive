extends Panel

export var pixels_per_leter := 20
export var screen_width = 1024

func _ready() -> void:
	Rakugo.connect("exec_statement", self, "_on_statement")
	Rakugo.notify_timer.connect("timeout", self, "hide")


func _on_statement(type: int, parameters: Dictionary) -> void:
	if type == Rakugo.StatementType.NOTIFY:
		$Label.bbcode_text = parameters.info
		var x = parameters.info.length() * pixels_per_leter
		var y = rect_min_size.y
		
		if x > screen_width:
			y = round(screen_width/x) * pixels_per_leter

		show()
		Rakugo.notified()
