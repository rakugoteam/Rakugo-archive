extends Node

const rakugo_version := "3.0.0"
const credits_path := "res://addons/Rakugo/credits.txt"

# project settings integration
onready var game_title : String = Settings.get("application/config/name")
onready var game_version : String = Settings.get("rakugo/game/info/version")
onready var game_credits : String = Settings.get("rakugo/game/info/credits")
onready var markup : String = Settings.get("rakugo/game/text/markup")#TODO remove that line 
onready var debug_on : bool = Settings.get("rakugo/editor/debug")#Same same
onready var scene_links : String = Settings.get("rakugo/game/scenes/scene_links")
onready var theme : RakugoTheme = load(Settings.get("rakugo/default/gui/theme"))


var current_scene_name := ""
var current_scene_path := ""
var current_scene_node: Node = null
var current_dialogue:Node = null setget set_current_dialogue

var store = null setget set_current_store, get_current_store
var persistent = null setget set_persistent_store, get_persistent_store 

# don't save this
var scene_anchor:Node


var active := false
var loading_in_progress := false
var started := false
var auto_stepping := false
var skipping := false

# timers use by rakugo
onready var auto_timer := $AutoTimer
onready var skip_timer := $SkipTimer

onready var SceneLoader: = $SceneLoader
onready var StoreManager: = $StoreManager
onready var ShowableManager: = $ShowableManager
onready var History: = $History
onready var TextParser: = $TextParser
onready var StepBlocker = $StepBlocker
onready var Say = $Statements/Say
onready var Ask = $Statements/Ask
onready var Menu = $Statements/Menu

signal say(character, text, parameters)
signal notify(text, parameters)
signal ask(default_answer, parameters)
signal ask_return(result)
signal menu(choices, parameters)
signal menu_return(result)
#TODO clean those
signal started()
signal game_ended()
#TODO assert the need of those
signal hide_ui(value)
#TODO prune those
signal play_anim(node_id, anim_name)
signal stop_anim(node_id, reset)
signal play_audio(node_id, from_pos)
signal stop_audio(node_id)

func _ready():
	self.scene_anchor = get_tree().get_root()
	StoreManager.init()
	History.init()

	OS.set_window_title(game_title + " " + game_version)

	#file.open(credits_path, file.READ)
	#define("rakugo_credits", file.get_as_text(), false)
	#file.close()



## Rakugo flow control

# it starts Rakugo
func start(after_load:bool = false):
	started = true
	if not after_load:
		emit_signal("started")


func save_game(save_name:String = "quick"):
	StoreManager.save_persistent_store()
	debug(["save data to :", save_name])
	return StoreManager.save_store_stack(save_name)
func load_game(save_name := "quick"):
	return StoreManager.load_store_stack(save_name)


func rollback(amount:int = 1):
	self.StoreManager.change_current_stack_index(self.StoreManager.current_store_id + amount)


func prepare_quitting():
	if self.started:
		self.save_game("auto")
	StoreManager.save_persistent_store()
	Settings.save_property_list()


func load_scene(scene_id:String, force_reload:bool = false):
	SceneLoader.load_scene(scene_id, force_reload)


func reset_game():
	SceneLoader.load_packed_scene(Settings.get("application/run/main_scene"))
	started = false
	emit_signal("game_ended")



## Dialogue flow control

func story_step(_unblock=false):
	if _unblock or not StepBlocker.is_blocking():
		StoreManager.stack_next_store()
		print("Emitting _step")
		get_tree().get_root().propagate_call('_step')
	else:
		print("Emitting _blocked_step")
		get_tree().get_root().propagate_call('_blocked_step')


func exit_dialogue():
	if self.current_dialogue:
		self.current_dialogue.exit()

func set_current_dialogue(new_dialogue:Dialogue):
	if current_dialogue != new_dialogue:
		exit_dialogue()
		current_dialogue = new_dialogue

func activate_skipping():
	self.skipping = true
	skip_timer.start()
func deactivate_skipping():
	self.skipping = false


func activate_auto_stepping():
	self.auto_stepping = true
	auto_timer.start()
func deactivate_auto_stepping():
	self.auto_stepping = false



## Utils

func clean_scene_anchor():
	if self.scene_anchor != get_tree().get_root():
		for c in self.scene_anchor.get_children():
			self.scene_anchor.remove_child(c)


# parse rich text markups to bbcode for RichTextLabel
# defaults to project setting if null
func parse_rich_text(text:String, markup = null):
	return TextParser.parse(text, markup)


# create new character, store it into current store ising its tag, then return it
func define_character(character_name:String, character_tag:String, color=null) -> Character:
	var new_character = Character.new()
	if color:
		new_character.init(character_name, character_tag, color)
	else:
		new_character.init(character_name, character_tag)
	StoreManager.get_current_store()[character_tag] = new_character
	return new_character


func debug_dict(parameters:Dictionary, parameters_names:Array = [], some_custom_text:String = "") -> String:
	var dbg = ""

	for k in parameters_names:
		if k in parameters:
			if not k in [null, ""]:
				dbg += k + ":" + str(parameters[k]) + ", "

	if parameters_names.size() > 0:
		dbg.erase(dbg.length() - 2, 2)

	return some_custom_text + dbg


# for printing debugs is only print if debug_on == true
# put some string array or string as argument
func debug(some_text = []):
	if not debug_on:
		return

	if not started:
		return	

	if typeof(some_text) == TYPE_ARRAY:
		var new_text = ""

		for i in some_text:
			new_text += str(i) + " "

		some_text = new_text

	print(some_text)



## Statements

# statement of type say
# its make given 'character' say 'text'
# 'parameters' keywords:typing, type_speed, avatar, avatar_state, add
# speed is time to show next letter
func say(character, text:String, parameters:Dictionary):
	Say.exec(character, text, parameters)


# statement of type ask
# with keywords: placeholder
func ask(default_answer:String, parameters:Dictionary):
	Ask.exec(default_answer, parameters)
func ask_return(result:String):
	Ask.return(result)


# statement of type menu
func menu(choices:Array, parameters:Dictionary):
	Menu.exec(choices, parameters)
func menu_return(result):
	Menu.return(result)


# it show nodes tagged with "showable <space separated tag>" depending of the tagging rules
func show(showable_tag:String, parameters := {}):
	ShowableManager.show(showable_tag, parameters)


# statement of type hide
func hide(showable_tag:String):
	ShowableManager.hide(showable_tag)


func notify(text:String, parameters:Dictionary):
	emit_signal('notify', text, parameters)


# use this to change/assign current scene and dialogue
# id_of_current_scene is id to scene defined in scene_links or full path to scene
func jump(scene_id:String, dialogue_name:String, event_name:String, force_reload:bool = false):
	$Statements/Jump.invoke(scene_id, dialogue_name, event_name, force_reload)



## Wrapper getters setters

func get_current_store():
	return StoreManager.get_current_store()
func set_current_store(value):
	return 

func get_persistent_store():
	return StoreManager.get_persistent_store()
func set_persistent_store(value):
	return 
