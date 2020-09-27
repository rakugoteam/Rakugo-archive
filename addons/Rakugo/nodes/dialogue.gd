extends Node
class_name Dialogue, "res://addons/Rakugo/icons/gdscript.svg"

export var default_starting_event = ""
export var auto_start = false

var exiting = false
var target = 0

var event_stack = []#LIFO stack
var condition_stacks = []#LIFO stack of a FIFO stack, hehe

var var_access = Mutex.new()
var thread = Thread.new()
var step_semaphore = Semaphore.new()

var jump_target = null

func reset():
	print("Resetting dialogue")
	exiting = false
	target = 0
	thread = Thread.new()
	step_semaphore = Semaphore.new()
	var_access = Mutex.new()
	jump_target = null
	if self.has_method(default_starting_event):
		event_stack = [[default_starting_event, 0, 0]]


func _ready() -> void:
	if self.auto_start and not Rakugo.current_dialogue:
		start()

func _store(save):
	if Rakugo.current_dialogue == self:
		print("Storing dialogue ",self.name, "  ", self.event_stack)
		save.current_dialogue = self.name
		save.current_dialogue_event_stack = self.event_stack.duplicate(true)
		save.current_dialogue_condition_stacks = self.condition_stacks.duplicate(true)

func _restore(save):
	if save.current_dialogue == self.name:
		print("Restoring dialogue ", self.name, self,"  ", save.current_dialogue_event_stack)
		self.exit()
		if not is_ended():
			print("Waiting for the thread to finish")
			thread.wait_to_finish()
			print("Thread finished")
		self.reset()
	
		print("Setting event_stack to  ", save.current_dialogue_event_stack)
		self.event_stack = save.current_dialogue_event_stack
		print("Setting condition_stacks to  ", save.current_dialogue_condition_stacks)
		self.condition_stacks = save.current_dialogue_condition_stacks
		Rakugo.current_dialogue = self
		print("Setting Rakugo.current_dialogue to  ",self, "  ", (Rakugo.current_dialogue == self))
		thread.start(self, "run")

func _step():
	print("_step received")
	if thread.is_active():
		print("Posting semaphore 1")
		self.step_semaphore.post()
	print(self, " ", Rakugo.current_dialogue)

func start(event_name=''):
	if event_name:
		event_stack = [[event_name, 0, 0]]
	elif self.has_method(default_starting_event):
		event_stack = [[default_starting_event, 0, 0]]
	else:
		push_error("Dialog '"+self.name+"' started without given event nor default event.")
	Rakugo.current_dialogue = self
	
	thread.start(self, "run")


func run(_a):
	print("Starting threaded dialog ", self, " ", event_stack)
	while event_stack:
		var e = event_stack.pop_front()
		print("calling ",e)
		self.call_event(e[0], e[1])
		if self.exiting:
			break
	if jump_target:
		Rakugo.call_deferred('jump', jump_target[0], jump_target[1], jump_target[2])
	#if Rakugo.current_dialogue == self:
	#	Rakugo.current_dialogue = null
	print("ending threaded dialog")
	thread.call_deferred('wait_to_finish')

func call_event(event, _target = 0):
	if is_active():
		self.target = _target
		self.call(event)

func start_event(event_name):
	var_access.lock()
	if event_stack:
		event_stack[0][1] += 1
	if not is_active():
		self.target = INF
	
	event_stack.push_front([event_name, 0, self.target])#Should be "get_stack()[1]['function']" instead of passing event_name
	if self.target:
		self.target = 0
	condition_stacks.push_front([])
	var_access.unlock()
	

func end_event():
	var_access.lock()
	event_stack.pop_front()
	event_stack[0][1] -= 1
	condition_stacks.pop_front()
	var_access.unlock()

func step():
	var_access.lock()
	if is_active():
		var_access.unlock()
		step_semaphore.wait()
	var_access.unlock()
	event_stack[0][1] += 1


func exit():
	print("Exitting Dialogue")
	#var_access.lock()
	self.exiting = true
	step_semaphore.post()
	#var_access.unlock()


func is_active():
	if event_stack:
		return not self.exiting and event_stack[0][1] >= event_stack[0][2]
	return not self.exiting


func is_ended():
	return not thread or not thread.is_active()

func get_event_stack():
	var output
	var_access.lock()
	output = event_stack.duplicate(true)
	var_access.unlock()
	return output


func get_step():
	return event_stack[0][1]


func get_target():
	return event_stack[0][1]


func story_step() -> void:
	Rakugo.story_step()


func cond(condition:bool):
	if is_active():
		condition_stacks[0].push_front(condition)
	else:
		condition = condition_stacks[0].pop_back()
	return condition
	

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
