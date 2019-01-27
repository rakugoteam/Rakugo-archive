extends Button

func _ready():
	connect("pressed", settings, "apply")

