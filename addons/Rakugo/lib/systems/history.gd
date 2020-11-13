extends Node

var last_say_hash = 0
var step_has_unseen = false
var log_step = true

var global_history = {}
var event_played = {}

func init():
	if Rakugo.persistent.get("global_history"):
		 global_history = Rakugo.persistent.get("global_history")


func _on_say(character, text, parameters):
	last_say_hash = hash_say(character, text, parameters)
	if not last_say_hash in global_history:
		step_has_unseen = true
	if log_step:
		var entry = HistoryEntry.new()
		var tag = ""
		if character:
			tag = character.tag
		entry.init(tag, text, parameters)
		Rakugo.store.history.push_front(entry)
		global_history[last_say_hash] = true #Using Dictionary as a python Set to benefit from the lookup table


func _store(store):
	log_step = true
	step_has_unseen = false
	last_say_hash = 0 #Remember to empty the hash_say !
	Rakugo.persistent.global_history =  global_history
	store.event_played = event_played.duplicate()


func _restore(store):
	log_step = false
	step_has_unseen = false
	last_say_hash = 0
	if Rakugo.persistent.get("global_history"):
		 global_history = Rakugo.persistent.get("global_history")
	if store.get("event_played"):
		event_played = store.get("event_played").duplicate()


func is_event_played(event_name:String, dialogue_name:String=""):
	if dialogue_name:
		var event_hash = hash_event(dialogue_name, event_name)
		return event_hash in event_played
	else:
		return event_name.hash() in event_played


func log_event(dialogue_name:String, event_name:String):
	var event_hash = hash_event(dialogue_name, event_name)
	if event_hash in event_played:
		event_played[event_hash] += 1# Counting because why not ?
	else: 
		event_played[event_hash] = 1
	
	var only_event_hash = event_name.hash()
	if only_event_hash in event_played:
		event_played[only_event_hash] += 1
	else: 
		event_played[only_event_hash] = 1


func hash_event(dialogue_name:String, event_name:String):
	var output = dialogue_name + "+" + event_name
	return output.hash()


func hash_say(character:Character, text:String, parameters:Dictionary):
	if not Rakugo.current_dialogue:
		return null
	
	var output = str(text.hash()) + Rakugo.current_dialogue.get_event_name()
	if character:
		output += character.name + character.tag
	else:
		output += Rakugo.Say.get_narrator().name
	if parameters and parameters.get("hash_parameters_in_history"):
		output += str(parameters.hash())
	
	return output.hash()
