extends Node
class_name Say

var default_parameters = {#TODO make those set by the project settings
	"add_to_history" : true,
	"typing" : false,
	}

var default_narrator = Character.new("Narrator", "")#TODO same as above


func exec(character:Character, text:String, parameters = {}) -> void:
	character = _get_character(character)
	parameters = _apply_default(parameters, character.say_parameters)# parameters > character default parameters > project parameters
	parameters = _apply_default(parameters, default_parameters)
	
	Rakugo.emit_signal("say", character, text, parameters)


#Utils functions

func _get_character(character):
	if character is String:
		character = Rakugo.get_current_store().get(character)
	if not character:
		character = default_narrator
	return character


func _apply_default(input:Dictionary, default:Dictionary):
	var output = input.duplicate()
	for k in default.keys():
		if not output.has(k):
			output[k] = default[k]
	return output
