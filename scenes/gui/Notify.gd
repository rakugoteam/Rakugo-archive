## This is in-game gui example for Ren API ##
## version: 0.5.0 ##
## License MIT ##

extends Panel

onready var ren	= get_node("/root/Window")

func _ready():
	ren.connect("enter_statement", self, "_on_statement")
	$Timer.connect("timeout", self, "hide")

func _on_statement(type, kwargs):
	if type == "notify":
		$Dialog.bbcode_text = kwargs.info
		if kwargs.has("length"):
			$Timer.wait_time=kwargs.length
		$Timer.start()
		show()
		ren.emit_signal("notified")


