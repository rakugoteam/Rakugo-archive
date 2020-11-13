extends Node

var default_parameters = {}


func _ready():
	default_parameters = Settings.get("rakugo/default/statements/default_menu_parameters", {}, false)


func exec(choices:Array, parameters = {}) -> void:
	parameters = _apply_default(parameters, default_parameters)
	Rakugo.StepBlocker.block('menu')
	Rakugo.emit_signal("menu", choices, parameters)


func return(result):
	Rakugo.emit_signal('menu_return', result)
	Rakugo.StepBlocker.unblock('menu')
	Rakugo.story_step()

#Utils functions

func _apply_default(input:Dictionary, default:Dictionary):
	var output = input.duplicate()
	for k in default.keys():
		if not output.has(k):
			output[k] = default[k]
	return output
