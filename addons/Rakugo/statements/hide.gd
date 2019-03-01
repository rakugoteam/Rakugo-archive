extends Statement
class_name Hide

func _init() -> void:
	._init()
	type = 5 # Rakugo.StatementType.HIDE
	parameters_names = ["node_id"]

func exec() -> void:
	debug(parameters_names)

	Rakugo.on_hide(parameters.node_id)
