extends Statement
class_name Hide

func _init() -> void:
	._init()
	type = 5 # Ren.StatementType.HIDE
	parameters_names = ["node_id"]

func exec() -> void:
	debug(parameters_names)

	Ren.on_hide(parameters.node_id)
