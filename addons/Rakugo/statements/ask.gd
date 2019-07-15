extends Say
class_name Ask

var value = "value"
var variable := "variable"

func _init() -> void:
	._init()
	type = 2 # Rakugo.StatementType.ASK
	parameters_names += ["temp", "variable"]


func exec() -> void:
	Rakugo.checkpoint()
	debug(parameters_names)

	value = parameters.value
	variable = parameters.variable

	if "value" in parameters:
		parameters["value"] = Rakugo.text_passer(parameters.value)

	.exec()


func on_exit(_type: int, new_parameters: Dictionary = {}) -> void:
	if !setup_exit(_type, new_parameters):
		return

	if "value" in parameters:
		value = parameters.value

	if "variable" in parameters:
		variable = parameters.variable

	if value.is_valid_integer():
		value = int(value)

	elif value.is_valid_float():
		value = float(value)

	Rakugo.define(variable, value)

	if parameters.add_to_history:
		add_to_history()

	Rakugo.story_step()
