extends Node

var default_parameters = {}


func _ready():
	default_parameters = Settings.get("rakugo/default/statements/default_ask_parameters", {}, false)


func exec(variable_name:String, parameters = {}) -> void:
	parameters = _apply_default(parameters, default_parameters)
	Rakugo.StepBlocker.block('ask')
	Rakugo.emit_signal("ask", variable_name, parameters)


func return(result):
	Rakugo.emit_signal('ask_return', result)
	Rakugo.StepBlocker.unblock('ask')
	Rakugo.story_step()

#Utils functions

func _apply_default(input:Dictionary, default:Dictionary):
	var output = input.duplicate()
	for k in default.keys():
		if not output.has(k):
			output[k] = default[k]
	return output
