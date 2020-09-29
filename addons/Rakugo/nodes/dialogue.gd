extends Node
class_name Dialogue, "res://addons/Rakugo/icons/dialogue.svg"

onready var _class_script_version = _get_dialogue_script_hash()
onready var _script_version = _get_script_hash()

export var default_starting_event = ""
export var auto_start = false
export var version_control = false

var exiting = false

#Those are only used as analogues of arguments
var target = 0
var condition_stack = []


var event_stack = []#LIFO stack of elements [event_name, current_counter, target, condition_stack(FIFO stack)]

var var_access = Mutex.new()#That mutex is probably completely useless
var thread = Thread.new()
var step_semaphore = Semaphore.new()

var jump_target = null

func reset(): ## Need to check if this is actually needed.
	#print("Resetting dialogue")
	exiting = false
	thread = Thread.new()
	step_semaphore = Semaphore.new()
	var_access = Mutex.new()
	jump_target = null
	if self.has_method(default_starting_event):
		event_stack = [[default_starting_event, 0, 0, []]]


func _ready():
	if self.auto_start and not Rakugo.current_dialogue:
		start()

func _store(save):
	if Rakugo.current_dialogue == self:
		#print("Storing dialogue ",self.name, "  ", self.event_stack)
		save.current_dialogue = self.name
		save.current_dialogue_event_stack = self.event_stack
		save.current_dialogue_script_version = _script_version
		save.dialogue_class_script_version = _class_script_version

func _restore(save):
	if save.current_dialogue == self.name:
		if save.dialogue_class_script_version != _class_script_version:
				push_warning("Dialogue class script mismatched.")
		if save.current_dialogue_script_version != _script_version:
			if version_control:
				push_error("The loaded save is not compatible with this version of the game.")
				return
			else:
				push_warning("Dialogue script mismatched, that may corrupt the game state.")
		
		#print("Restoring dialogue ", self.name, self,"  ", save.current_dialogue_event_stack)
		self.exit()
		if not is_ended():
			#print("Waiting for the thread to finish")
			thread.wait_to_finish()
			#print("Thread finished")
		self.reset()
	
		#print("Setting event_stack to  ", save.current_dialogue_event_stack)
		var_access.lock()
		event_stack = save.current_dialogue_event_stack
		self.var_access.unlock()
		Rakugo.current_dialogue = self
		#print("Setting Rakugo.current_dialogue to  ",self, "  ", (Rakugo.current_dialogue == self))
		thread.start(self, "dialogue_loop")

func _step():
	#print("_step received")
	if thread.is_active():
		self.step_semaphore.post()
	print(self, " ", Rakugo.current_dialogue)

func start(event_name=''):
	var_access.lock()
	if event_name:
		event_stack = [[event_name, 0, 0, []]]
	elif self.has_method(default_starting_event):
		event_stack = [[default_starting_event, 0, 0, []]]
	else:
		push_error("Dialog '"+self.name+"' started without given event nor default event.")
	var_access.unlock()
	Rakugo.current_dialogue = self
	thread.start(self, "dialogue_loop")



## Thread life cycle

func dialogue_loop(_a):
	var_access.lock()
	#print("Starting threaded dialog ", self, " ", event_stack)
	while event_stack:
		var e = event_stack.pop_front()
		var_access.unlock()
		#print("Calling event ",e)
		self.call_event(e[0], e[1], e[3])
		var_access.lock()
		if self.exiting:
			break
	if jump_target:
		Rakugo.call_deferred('jump', jump_target[0], jump_target[1], jump_target[2])
	var_access.unlock()

	#print("Ending threaded dialog")
	thread.call_deferred('wait_to_finish')


func exit():
	if not is_ended():## Not checking for active thread makes the mutex deadlocks somehow
		#print("Exitting Dialogue")
		var_access.lock()
		self.exiting = true
		var_access.unlock()
		step_semaphore.post()


func is_ended():
	return not thread or not thread.is_active()



## Events Flow control and Administration

func call_event(event, _target = 0, _condition_stack = []):
	if is_active():
		#Using class vars to make event methods argument less.
		var_access.lock()
		self.target = _target
		self.condition_stack = _condition_stack.duplicate()
		var_access.unlock()
		self.call(event)

func start_event(event_name):
	var_access.lock()
	if event_stack:
		event_stack[0][1] += 1# Disalign step counter in case of saving before returning
	if not is_active():
		event_stack.push_front([event_name, 0, INF, self.condition_stack])
	else:
		event_stack.push_front([event_name, 0, self.target, self.condition_stack])#Should be "get_stack()[1]['function']" instead of passing event_name, if get_stack() worked
	var_access.unlock()

func cond(condition:bool):
	var_access.lock()
	if is_active(true):
		event_stack[0][3].push_front(condition)
	else:
		condition = event_stack[0][3].pop_back()
	var_access.unlock()
	return condition

func step():
	if is_active():
		step_semaphore.wait()
	var_access.lock()
	event_stack[0][1] += 1
	var_access.unlock()

func end_event():
	var_access.lock()
	event_stack.pop_front()
	event_stack[0][1] -= 1# Realign step counter before returning
	var_access.unlock()


func is_active(_strict=false):
	var_access.lock()
	var output:bool = not self.exiting
	if event_stack:
		if _strict:# Allow to check if it's the last step until waiting for semaphore
			output = output and event_stack[0][1] > event_stack[0][2]
		else:
			output = output and event_stack[0][1] >= event_stack[0][2]
	var_access.unlock()
	return output



## The "Framework" section
# ,the section of methods there "just in case" that should probably be removed

func get_event_stack():
	var output
	var_access.lock()
	output = event_stack.duplicate(true)
	var_access.unlock()
	return output


func get_event_step():
	var output
	var_access.lock()
	output = event_stack[0][1]
	var_access.unlock()
	return output


func get_parent_event_name():
	var output = ''
	var_access.lock()
	if event_stack.size() > 1:
		output = event_stack[1][0]
	var_access.unlock()
	return output


func story_step() -> void:
	Rakugo.story_step()#Don't remember why I put that here, probably a leftover from the old system

## Version control
# 

func _get_dialogue_script_hash():
	return load("res://addons/Rakugo/nodes/dialogue.gd").new()._get_script_hash()

func _get_script_hash(object=self):
	return object.get_script().source_code.hash()


## Rakugo statement wrap

func define(var_name: String, value = null, save_included := true) -> RakugoVar:
	if is_active():
		return Rakugo.define(var_name, value, save_included)
	return null


func ranged_var(var_name: String, start_value := 0.0, min_value := 0.0, max_value := 0.0) -> RakugoRangedVar:
	if is_active():
		return Rakugo.ranged_var(var_name, start_value, min_value, max_value)
	return null


func character(character_id: String, parameters :={}) -> CharacterObject:
	if is_active():
		return Rakugo.character(character_id, parameters)
	return null


func set_var(var_name: String, value) -> RakugoVar:
	if is_active():
		return Rakugo.set_var(var_name, value)
	return null


func get_var(var_name: String) -> RakugoVar:
	if is_active():
		return Rakugo.get_var(var_name)
	return null


func get_value(var_name: String):
	if is_active():
		return Rakugo.get_value(var_name)


func say(parameters: Dictionary) -> void:
	if is_active():
		Rakugo.call_deferred('say', parameters)


func ask(parameters: Dictionary) -> void:
	if is_active():
		Rakugo.call_deferred('ask', parameters)


func menu(parameters: Dictionary) -> void:
	if is_active():
		if not ("node" in parameters):
			parameters["node"] = self
		Rakugo.call_deferred('menu', parameters)


func show(node_id: String, parameters := {"state": []}):
	if is_active():
		Rakugo.call_deferred('show', node_id, parameters)


func hide(node_id: String) -> void:
	if is_active():
		Rakugo.call_deferred('hide', node_id)


func notify(info: String, length: int = get_value("notify_time")) -> void:
	if is_active():
		Rakugo.call_deferred('notify', info, length)


func play_anim( node_id: String, anim_name: String) -> void:
	if is_active():
		Rakugo.call_deferred('play_anim', node_id, anim_name)


func stop_anim(node_id: String, reset := true) -> void:
	if is_active():
		Rakugo.call_deferred('stop_anim', node_id, reset)


func play_audio(node_id: String, from_pos := 0.0) -> void:
	if is_active():
		Rakugo.call_deferred('play_audio', node_id, from_pos)


func stop_audio(node_id: String) -> void:
	if is_active():
		Rakugo.call_deferred('stop_audio', node_id)


func call_node(node_id: String, func_name: String, args := []) -> void:
	if is_active():
		Rakugo.call_deferred('call_node', node_id, func_name, args)


func jump(scene_id: String, dialogue_name: String, event_name: String) -> void:
	if is_active():
		self.jump_target = [scene_id, dialogue_name, event_name]
		self.exit()


func end_game() -> void:
	if is_active():
		Rakugo.call_deferred('end_game')
