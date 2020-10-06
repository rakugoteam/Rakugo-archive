extends Node
class_name Menu

var default_parameters = {#TODO make those set by the project settings
	
	}


func exec(choices:Array, parameters = {}) -> void:
	parameters = _apply_default(parameters, default_parameters)
	
	Rakugo.emit_signal("menu", choices, parameters)


#Utils functions

func _apply_default(input:Dictionary, default:Dictionary):
	var output = input.duplicate()
	for k in default.keys():
		if not output.has(k):
			output[k] = default[k]
	return output


#This class is actually pretty empty other than the boilerplate _apply_default, but adding when the default_parameter will be in the settings then it should get some specific code
