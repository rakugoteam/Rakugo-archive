extends Panel

func _ready():
	Ren.connect("exec_statement", self, "_on_statement")
	$Timer.connect("timeout", self, "hide")

func _on_statement(type, kwargs):
	if type == "notify":
		$Dialog.bbcode_text = kwargs.info
		if kwargs.has("length"):
			$Timer.wait_time = kwargs.length
		$Timer.start()
		show()
		Ren.notified()


