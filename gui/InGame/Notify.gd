extends Panel

func _ready():
	Ren.connect("exec_statement", self, "_on_statement")
	Ren.notify_timer.connect("timeout", self, "hide")

func _on_statement(type, parameters):
	if type == Ren.StatementType.NOTIFY:
		$Dialog.bbcode_text = parameters.info
		show()
		Ren.notified()


