extends Panel

func _ready() -> void:
	Rakugo.connect("exec_statement", self, "_on_statement")
	Rakugo.notify_timer.connect("timeout", self, "hide")


func _on_statement(type: int, parameters: Dictionary) -> void:
	if type == Rakugo.StatementType.NOTIFY:
		$Dialog.bbcode_text = parameters.info
		show()
		Rakugo.notified()
