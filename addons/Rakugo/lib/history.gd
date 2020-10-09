extends Node

var last_say_hash = 0
var step_has_unseen = false
var log_step = true

var global_history = {}#TODO replace it by a persistent global history

func _on_say(character, text, parameters):
	last_say_hash = hash_say(character, text, parameters)
	if not last_say_hash in global_history:
		step_has_unseen = true
	if log_step:
		var entry = HistoryEntry.new()
		entry.init(character, text, parameters)
		Rakugo.store.history.push_front(entry)
		global_history[last_say_hash] = 0 #Using Dictionary as a python Set to benefit from the lookup table

func _store(store):
	log_step = true
	step_has_unseen = false
	last_say_hash = 0 #Remember to empty the hash_say !

func _restore(store):
	log_step = false
	step_has_unseen = false
	last_say_hash = 0

func hash_say(character:Character, text:String, parameters:Dictionary):
	if not Rakugo.current_dialogue:
		return null
	
	var output = str(text.hash()) + Rakugo.current_dialogue.get_event_name()
	if character:
		output += character.name + character.tag
	if parameters and parameters.get("hash_parameters_in_history"):
		output += str(parameters.hash())
	
	return output.hash()
