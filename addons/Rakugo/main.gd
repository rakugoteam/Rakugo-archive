extends Node

## don't change - to be removed / change how it works
var test_save := true

const rakugo_version:= "2.0.0"
const credits_path:= "res://addons/Rakugo/credits.txt"

# we need it because we hide base RakugoMenu form custom nodes
const RakugoMenu:= preload("res://addons/Rakugo/nodes/rakugo_menu.gd")

# project settings integration
onready var game_title = ProjectSettings.get_setting("application/config/name")
onready var game_version = ProjectSettings.get_setting("application/rakugo/version")
onready var game_credits = ProjectSettings.get_setting("application/rakugo/game_credits")
onready var markup = ProjectSettings.get_setting("application/rakugo/markup")
onready var debug_on = ProjectSettings.get_setting("application/rakugo/debug")
onready var scenes_links = ProjectSettings.get_setting("application/rakugo/scenes_links")
onready var save_folder = ProjectSettings.get_setting("application/rakugo/save_folder")
onready var theme = load(ProjectSettings.get_setting("application/rakugo/theme"))
onready var default_kind = ProjectSettings.get_setting("application/rakugo/default_kind")

## init vars for settings
var _skip_all_text:= false
var _skip_after_choices:= false
var _auto_time:= 1
var _text_time:= 0.3
var _notify_time:= 3
var _typing_text:= true

enum Type {
	VAR,		# 0
	TEXT,		# 1
	DICT,		# 2
	LIST,		# 3
	NODE,		# 4
	QUEST,		# 5
	SUBQUEST,	# 6
	CHARACTER,	# 7
	RANGED,		# 8
	BOOL,		# 9
	VECT2, # 10
	VECT3, # 11
	VECT4, # 12
	COLOR, # 13
}

enum StatementType {
	BASE,		# 0
	SAY,		# 1
	ASK,		# 2
	MENU,		# 3
	SHOW,		# 4
	HIDE,		# 5
	NOTIFY,		# 6
	PLAY_ANIM,	# 7
	STOP_ANIM,	# 8
	PLAY_AUDIO,	# 9
	STOP_AUDIO,	# 10
	CALL_NODE,	# 11
}

# this must be saved
var history_id:= 0 setget _set_history_id, _get_history_id
var current_dialog_name:= ""
var current_node_name:= ""
var current_scene:= ""

# {["scene_id", "node_name", "dialog_name", story_step]:{"type":type, "parameters": parameters}}
var history:= {}
var global_history:= {}

var variables:= {}

# don't save this
onready var menu_node:RakugoMenu = $Menu
var current_root_node:Node = null
var current_statement:Statement = null
var skip_auto:= false
var active:= false
var can_alphanumeric:= true
var emoji_size := 16
var skipping := false

var skip_types:= [
	StatementType.SAY,
	StatementType.SHOW,
	StatementType.HIDE,
	StatementType.NOTIFY,
	StatementType.PLAY_ANIM,
	StatementType.STOP_ANIM,
	StatementType.PLAY_AUDIO,
	StatementType.STOP_AUDIO,
	StatementType.CALL_NODE,
]

const weekdays = {
	0: 'Sunday',
	1: 'Monday',
	2: 'Tuesday',
	3: 'Wednesday',
	4: 'Thrusday',
	5: 'Friday',
	6: 'Saturday',
}

const months = {
	1: 'January',
	2: 'February',
	3: 'March',
	4: 'April',
	5: 'May',
	6: 'June',
	7: 'July',
	8: 'August',
	9: 'September',
	10: 'October',
	11: 'November',
	12: 'December',
}

var file:= File.new()
var loading_in_progress:= false
var started:= false
var quests:= [] # list of all quests ids

# timers use by rakugo
onready var auto_timer:= $AutoTimer
onready var skip_timer:= $SkipTimer
onready var step_timer:= $StepTimer
onready var dialog_timer:= $DialogTimer
onready var notify_timer:= $NotifyTimer

## saved automatically - it is RagukoVar
var story_state:int setget _set_story_state, _get_story_state

signal started
signal exec_statement(type, parameters)
signal exit_statement(previous_type, parameters)
signal notified()
signal show(node_id, state, show_args)
signal hide(node_id)
signal story_step(node_name, dialog_name)
signal play_anim(node_id, anim_name)
signal stop_anim(node_id, reset)
signal play_audio(node_id, from_pos)
signal stop_audio(node_id)
signal begin
signal hide_ui(value)
signal checkpoint

func _ready() -> void:
	## set by game developer
	define("title", game_title, false)
	define("version", game_version, false)
	OS.set_window_title(game_title + " " + game_version)
	define("credits", game_credits, false)

	## it must be before define rakugo_version and godot_version to parse corretly :o
	file.open(credits_path, file.READ)
	define("rakugo_credits", file.get_as_text(), false)
	file.close()

	## set by rakugo
	define("rakugo_version", rakugo_version, false)

	var gdv = Engine.get_version_info()
	var gdv_string = str(gdv.major) + "." + str(gdv.minor) + "." + str(gdv.patch)
	define("godot_version", gdv_string, false)

	define("story_state", 0)

	## vars for rakugo settings
	## `false` because is loaded from settings and not from save
	define("skip_all_text", _skip_all_text, false)
	define("skip_after_choices", _skip_after_choices, false)
	define("auto_time", _auto_time, false)
	define("text_time", _text_time, false)
	define("notify_time", _notify_time, false)
	define("typing_text", _typing_text, false)

	## consts
	## Colors
	character("Narrator")
	define("gray", Color.gray, false)
	define("aliceblue", Color.aliceblue, false)
	define("antiquewhite", Color.antiquewhite, false)
	define("aqua", Color.aqua, false)
	define("aquamarine", Color.aquamarine, false)
	define("azure", Color.azure, false)
	define("beige", Color.beige, false)
	define("bisque", Color.bisque, false)
	define("black", Color.black, false)
	define("blanchedalmond", Color.blanchedalmond, false)
	define("blue", Color.blue, false)
	define("blueviolet", Color.blueviolet, false)
	define("brown", Color.brown, false)
	define("burlywood", Color.burlywood, false)
	define("cadetblue", Color.cadetblue, false)
	define("chartreuse", Color.chartreuse, false)
	define("chocolate", Color.chocolate, false)
	define("coral", Color.coral, false)
	define("cornflower", Color.cornflower, false)
	define("cornsilk", Color.cornsilk, false)
	define("crimson", Color.crimson, false)
	define("cyan", Color.cyan, false)
	define("darkblue", Color.darkblue, false)
	define("darkcyan", Color.darkcyan, false)
	define("darkgoldenrod", Color.darkgoldenrod, false)
	define("darkgray", Color.darkgray, false)
	define("darkgreen", Color.darkgreen, false)
	define("darkkhaki", Color.darkkhaki, false)
	define("darkmagenta", Color.darkmagenta, false)
	define("darkolivegreen", Color.darkolivegreen, false)
	define("darkorange", Color.darkorange, false)
	define("darkorchid", Color.darkorchid, false)
	define("darkred", Color.darkred, false)
	define("darksalmon", Color.darksalmon, false)
	define("darkseagreen", Color.darkseagreen, false)
	define("darkslateblue", Color.darkslateblue, false)
	define("darkslategray", Color.darkslategray, false)
	define("darkturquoise", Color.darkturquoise, false)
	define("darkviolet", Color.darkviolet, false)
	define("deeppink", Color.deeppink, false)
	define("deepskyblue", Color.deepskyblue, false)
	define("dimgray", Color.dimgray, false)
	define("dodgerblue", Color.dodgerblue, false)
	define("firebrick", Color.firebrick, false)
	define("floralwhite", Color.floralwhite, false)
	define("forestgreen", Color.forestgreen, false)
	define("fuchsia", Color.fuchsia, false)
	define("gainsboro", Color.gainsboro, false)
	define("ghostwhite", Color.ghostwhite, false)
	define("gold", Color.gold, false)
	define("goldenrod", Color.goldenrod, false)
	define("green", Color.green, false)
	define("greenyellow", Color.greenyellow, false)
	define("honeydew", Color.honeydew, false)
	define("hotpink", Color.hotpink, false)
	define("indianred", Color.indianred, false)
	define("indigo", Color.indigo, false)
	define("ivory", Color.ivory, false)
	define("khaki", Color.khaki, false)
	define("lavender", Color.lavender, false)
	define("lavenderblush", Color.lavenderblush, false)
	define("lawngreen", Color.lawngreen, false)
	define("lemonchiffon", Color.lemonchiffon, false)
	define("lightblue", Color.lightblue, false)
	define("lightcoral", Color.lightcoral, false)
	define("lightcyan", Color.lightcyan, false)
	define("lightgoldenrod", Color.lightgoldenrod, false)
	define("lightgray", Color.lightgray, false)
	define("lightgreen", Color.lightgreen, false)
	define("lightpink", Color.lightpink, false)
	define("lightsalmon", Color.lightsalmon, false)
	define("lightseagreen", Color.lightseagreen, false)
	define("lightskyblue", Color.lightskyblue, false)
	define("lightslategray", Color.lightslategray, false)
	define("lightsteelblue", Color.lightsteelblue, false)
	define("lightyellow", Color.lightyellow, false)
	define("lime", Color.lime, false)
	define("limegreen", Color.limegreen, false)
	define("linen", Color.linen, false)
	define("magenta", Color.magenta, false)
	define("maroon", Color.maroon, false)
	define("mediumaquamarine", Color.mediumaquamarine, false)
	define("mediumblue", Color.mediumblue, false)
	define("mediumorchid", Color.mediumorchid, false)
	define("mediumpurple", Color.mediumpurple, false)
	define("mediumseagreen", Color.mediumseagreen, false)
	define("mediumslateblue", Color.mediumslateblue, false)
	define("mediumspringgreen", Color.mediumspringgreen, false)
	define("mediumturquoise", Color.mediumturquoise, false)
	define("mediumvioletred", Color.mediumvioletred, false)
	define("midnightblue", Color.midnightblue, false)
	define("mintcream", Color.mintcream, false)
	define("mistyrose", Color.mistyrose, false)
	define("moccasin", Color.moccasin, false)
	define("navajowhite", Color.navajowhite, false)
	define("navyblue", Color.navyblue, false)
	define("oldlace", Color.oldlace, false)
	define("olive", Color.olive, false)
	define("olivedrab", Color.olivedrab, false)
	define("orange", Color.orange, false)
	define("orangered", Color.orangered, false)
	define("orchid", Color.orchid, false)
	define("palegoldenrod", Color.palegoldenrod, false)
	define("palegreen", Color.palegreen, false)
	define("paleturquoise", Color.paleturquoise, false)
	define("palevioletred", Color.palevioletred, false)
	define("papayawhip", Color.papayawhip, false)
	define("peachpuff", Color.peachpuff, false)
	define("peru", Color.peru, false)
	define("pink", Color.pink, false)
	define("plum", Color.plum, false)
	define("powderblue", Color.powderblue, false)
	define("purple", Color.purple, false)
	define("rebeccapurple", Color.rebeccapurple, false)
	define("red", Color.red, false)
	define("rosybrown", Color.rosybrown, false)
	define("royalblue", Color.royalblue, false)
	define("saddlebrown", Color.saddlebrown, false)
	define("salmon", Color.salmon, false)
	define("sandybrown", Color.sandybrown, false)
	define("seagreen", Color.seagreen, false)
	define("seashell", Color.seashell, false)
	define("sienna", Color.sienna, false)
	define("silver", Color.silver, false)
	define("skyblue", Color.skyblue, false)
	define("slateblue", Color.slateblue, false)
	define("slategray", Color.slategray, false)
	define("snow", Color.snow, false)
	define("springgreen", Color.springgreen, false)
	define("steelblue", Color.steelblue, false)
	define("tan", Color.tan, false)
	define("teal", Color.teal, false)
	define("thistle", Color.thistle, false)
	define("tomato", Color.tomato, false)
	define("turquoise", Color.turquoise, false)
	define("violet", Color.violet, false)
	define("webgray", Color.webgray, false)
	define("webgreen", Color.webgreen, false)
	define("webmaroon", Color.webmaroon, false)
	define("webpurple", Color.webpurple, false)
	define("wheat", Color.wheat, false)
	define("white", Color.white, false)
	define("whitesmoke", Color.whitesmoke, false)
	define("yellow", Color.yellow, false)
	define("yellowgreen", Color.yellowgreen, false)

	## conts
	## Vectors2
	define("v2_zero", Vector2.ZERO, false)
	define("v2_one", Vector2.ONE, false)
	define("v2_inf", Vector2.INF, false)
	define("v2_left", Vector2.LEFT, false)
	define("v2_right", Vector2.RIGHT, false)
	define("v2_up", Vector2.UP, false)
	define("v2_down", Vector2.DOWN, false)

	## conts
	## Vectors3
	define("v3_zero", Vector3.ZERO, false)
	define("v3_one", Vector3.ONE, false)
	define("v3_inf", Vector3.INF, false)
	define("v3_left", Vector3.LEFT, false)
	define("v3_right", Vector3.RIGHT, false)
	define("v3_up", Vector3.UP, false)
	define("v3_down", Vector3.DOWN, false)
	define("v3_forward", Vector3.FORWARD, false)
	define("v3_back", Vector3.BACK, false)

	step_timer.connect("timeout", self, "_on_time_active_timeout")

func get_datetime_str() -> String:
	var d = OS.get_datetime()
	return weekdays[d['weekday']] + ' ' + months[d['month']] + ' ' + str(d['day']) + ', ' + str(d['hour']) + ':' + str(d['minute'])

func _on_time_active_timeout() -> void:
	active = true

func exec_statement(type:int, parameters:= {}) -> void:
	emit_signal("exec_statement", type, parameters)

func exit_statement(parameters:= {}) -> void:
	emit_signal("exit_statement", current_statement.type, parameters)

func story_step() -> void:
	emit_signal("story_step", current_node_name, current_dialog_name)

func notified() -> void:
	emit_signal("notified")

func on_show(node_id:String, state:Array, show_args:Dictionary) -> void:
	emit_signal("show", node_id, state, show_args)

func on_hide(node_id:String) -> void:
	emit_signal("hide", node_id)

func on_play_anim(node_id:String, anim_name:String) -> void:
	emit_signal("play_anim", node_id, anim_name)

func on_stop_anim(node_id:String, reset:bool) -> void:
	emit_signal("stop_anim", node_id, reset)

func on_play_audio(node_id:String, from_pos:float) -> void:
	emit_signal("play_audio", node_id, from_pos)

func on_stop_audio(node_id:String) -> void:
	emit_signal("stop_audio", node_id)

## use to add/register dialog
## func_name is name of func that is going to be use as dialog
func add_dialog(node:Node, func_name:String) -> void:
	connect("story_step", node, func_name)

## parse text like in renpy to bbcode if mode == "renpy"
## or parse bbcode with {vars} if mode == "bbcode"
## default mode = Rakugo.markup
func text_passer(text:String, mode:= markup):
	return $Text.text_passer(text, variables, mode, theme.links_color.to_html())

## add/overwrite global variable that Rakugo will see
## and returns it as RakugoVar for easy use
func define(var_name:String, value = null, save_included := true) -> RakugoVar:
	var v = $Define.invoke(var_name, value , save_included)

	if v:
		return v

	else:
		return set_var(var_name, value)

func str2value(str_value : String, var_type : String):
	match var_type:
		"str":
			return str_value

		"bool":
			return bool(str_value)

		"int":
			return int(str_value)

		"float":
			return float(str_value)

## add/overwrite global variable, from string, that Rakugo will see
func define_from_str(var_name:String, var_str:String, var_type:String) -> RakugoVar:
	var value = str2value(var_str, var_type)
	if not variables.has(var_name):
		return define(var_name, value)

	return set_var(var_name, value)

## overwrite existing global variable and returns it as RakugoVar
func set_var(var_name:String, value) -> RakugoVar:
	if not (var_name in variables):
		prints(var_name, "variable don't exist in Rakugo")
		return null

	var var_to_change = variables[var_name]
	var_to_change.value = value
	return var_to_change

## returns exiting Rakugo variable as one of RakugoTypes for easy use
## It must be with out returned type, because we can't set it as list of types
func get_var(var_name:String) -> RakugoVar:
	return $GetVar.invoke(var_name)

## to use with `define_from_str` func as var_type arg
## it can't use optional typing
func get_def_type(variable) -> String:
	var type = "str"

	match typeof(variable):
		TYPE_BOOL:
			type = "bool"

		TYPE_INT:
			type = "int"

		TYPE_REAL:
			type = "float"

	return type

## returns value of variable defined using define
## It must be with out returned type, because we can't set it as list of types
func get_value(var_name:String):
	if variables.has(var_name):
		return variables[var_name].value

	return null

func get_node_value(var_name:String) -> Dictionary:
	var s = NodeLink.new("").var_suffix
	return get_value(s + var_name)

## returns type of variable defined using define
func get_type(var_name:String) -> int:
	return variables[var_name].type

## just faster way to connect signal to rakugo's variable
func connect_var(
	var_name:String, signal_name:String,
	node:Object, func_name:String,
	binds:= [], flags:= 0
	) -> void:

	get_var(var_name).connect(
		signal_name, node, func_name,
		binds, flags
	)

## crate new RangedVar as global variable that Rakugo will see
func ranged_var(var_name, start_value := 0.0, min_value := 0.0, max_value := 0.0) -> RakugoRangedVar:
	var rrv = RakugoRangedVar.new(var_name, start_value, min_value, max_value)
	variables[var_name] = rrv
	return rrv

## crate new character as global variable that Rakugo will see
## possible parameters: name, color, prefix, suffix, avatar, stats, kind
func character(character_id:String, parameters:={}) -> CharacterObject:
	var new_ch := CharacterObject.new(character_id, parameters)
	variables[character_id] = new_ch
	return new_ch

## crate new link to node as global variable that Rakugo will see
## it can have name as other existing varbiable
func node_link(node_id:String, node:NodePath) -> NodeLink:
	return $Define.node_link(node_id, node, variables)

func get_node_link(node_id:String) -> NodeLink:
	var s = NodeLink.new("").var_suffix
	return get_var(s + node_id) as NodeLink

## add/overwrite global subquest that Rakugo will see
## and returns it as RakugoSubQuest for easy use
## possible parameters: "who", "title", "description", "optional", "state", "subquests"
func subquest(subquest_id:String, parameters:= {}) -> Subquest:
	var new_subq : = Subquest.new(subquest_id, parameters)
	return new_subq

## add/overwrite global quest that Rakugo will see
## and returns it as RakugoQuest for easy use
## possible parameters: "who", "title", "description", "optional", "state", "subquests"
func quest(quest_id:String, parameters:={}) -> Quest:
	var q := Quest.new(quest_id, parameters)
	quests.append(quest_id)
	return q

## it should be "node:Statement", but it don't work for now
func _set_statement(node:Node, parameters:Dictionary) -> void:
	node.set_parameters(parameters)
	node.exec()
	active = false
	step_timer.start()

## statement of type say
## there can be only one say, ask or menu in story_state at it end
## its make given character(who) talk (what)
## with keywords: who, what, typing, kind, avatar, avatar_state
## speed is time to show next letter
func say(parameters:Dictionary) -> void:
	_set_statement($Say, parameters)

## statement of type ask
## there can be only one say, ask or menu in story_state at it end
## its allow player to provide keyboard ask that will be assign to given variable
## it also will return RakugoVar variable
## with keywords:who, what, typing, kind, variable, value
## speed is time to show next letter
func ask(parameters:Dictionary) -> void:
	_set_statement($Ask, parameters)

## statement of type menu
## there can be only one say, ask or menu in story_state at it end
## its allow player to make choice
## with keywords:who, what, typing, kind, choices, mkind
## speed is time to show next letter
func menu(parameters:Dictionary) -> void:
	_set_statement($Menu, parameters)

## it show custom rakugo node or character
## 'state' arg is using to set for example current emotion or/and cloths
## 'state' example '['happy', 'green uniform']'
## with keywords:x, y, z, at, pos
## x, y and pos will use it as protect of screen if between 0 and 1
## "at" is lists that can have: "top", "center", "bottom", "right", "left"
func show(
	node_id:String,
	parameters := {"state": [], "at":["center", "bottom"]}
	):

	parameters["node_id"] = node_id
	_set_statement($Show, parameters)

## statement of type hide
func hide(node_id:String) -> void:
	var parameters = {
		"node_id":node_id
	}

	_set_statement($Hide, parameters)

## statement of type notify
func notify(
	info:String,
	length:int = get_value("notify_time")
	) -> void:

	var parameters = {
		"info": info,
		"length":length
	}

	_set_statement($Notify, parameters)
	notify_timer.wait_time = parameters.length
	notify_timer.start()

## statement of type play_anim
## it will play animation with anim_name form RakugoAnimPlayer with given node_id
func play_anim(
	node_id:String,
	anim_name:String
	) -> void:

	var parameters = {
		"node_id":node_id,
		"anim_name":anim_name
	}

	_set_statement($PlayAnim, parameters)

## statement of type stop_anim
## it will stop animation form RakugoAnimPlayer with given node_id
## and by default is reset to 0 pos on exit from statment
func stop_anim(node_id:String, reset:= true) -> void:
	var parameters = {
		"node_id":node_id,
		"reset":reset
	}

	_set_statement($StopAnim, parameters)

## statement of type play_audio
## it will play audio form RakugoAudioPlayer with given node_id
## it will start playing from given from_pos
func play_audio(node_id:String, from_pos:= 0.0) -> void:
	var parameters = {
		"node_id":node_id,
		"from_pos":from_pos
	}

	_set_statement($PlayAudio, parameters)

## statement of type stop_audio
## it will stop audio form RakugoAudioPlayer with given node_id
func stop_audio(node_id:String) -> void:
	var parameters = {
		"node_id":node_id
	}

	_set_statement($StopAudio, parameters)

## statement of type stop_audio
## it will stop audio form RakugoAudioPlayer with given node_id
func call_node(node_id:String, func_name:String, args:= []) -> void:
	var parameters = {
		"node_id":node_id,
		"func_name":func_name,
		"args":args
	}

	_set_statement($CallNode, parameters)

func _set_story_state(state:int) -> void:
	define("story_state", state)

func _get_story_state() -> int:
	return get_value("story_state")

## it starts Rakugo
func start(after_load := false) -> void:
	load_global_history()
	history_id = 0
	started = true

	if not after_load:
		emit_signal("started")
		story_step()

func savefile(save_name:= "quick") -> bool:
	debug(["save data to :", save_name])
	return $SaveFile.invoke(save_name)

func loadfile(save_name:= "quick") -> bool:
	return $LoadFile.invoke(save_folder, save_name, variables)

func debug_dict(
	parameters:Dictionary,
	parameters_names:= [],
	some_custom_text:= ""
	) -> String:

	var dbg = ""

	for k in parameters_names:
		if k in parameters:
			if not k in [null, ""]:
				dbg += k + ":" + str(parameters[k]) + ", "

	if parameters_names.size() > 0:
		dbg.erase(dbg.length() - 2, 2)

	return some_custom_text + dbg

## for printing debugs is only print if debug_on == true
## put some string array or string as argument
func debug(some_text = []) -> void:
	if not debug_on:
		return

	if typeof(some_text) == TYPE_ARRAY:
		var new_text = ""

		for i in some_text:
			new_text += str(i) + " "

		some_text = new_text

	print(some_text)

func _set_history_id(value:int) -> void:
	history_id = value

func _get_history_id() -> int:
	return history_id

## use this to change/assign current scene and dialog
## id_of_current_scene is id to scene defined in scenes_links or full path to scene
func jump(
	id_of_scene:String, node_name:String,
	dialog_name:String, change:= true, state := 0
	) -> void:

	$Jump.invoke(
		id_of_scene,
		node_name, dialog_name,
		change, state
	)

## use this to assign beginning scene and dialog
## root of path_to_current_scene is scenes_dir
## provide path_to_current_scene with out ".tscn"
func on_begin(path_to_current_scene:String, node_name:String, dialog_name:String) -> void:
	if loading_in_progress:
		return

	jump(path_to_current_scene, node_name , dialog_name, false)

func can_go_back():
	return is_save_exits("back")

func checkpoint():
	if savefile("back"):
		emit_signal("checkpoint")

func go_back():
	loadfile("back")

func is_current_statement_in_global_history() -> bool:

	if not current_statement.parameters.add_to_history:
		return true

	var id = current_statement.get_history_id()
	var c_item = current_statement.get_as_history_item()

	if global_history.has(id):
		var type = c_item.type
		var parameters = c_item.parameters

		if type == global_history[id].type:
			var hi_parameters = global_history[id].parameters

			if parameters.size() == hi_parameters.size():
				var keys = parameters.keys()
				var hi_keys = hi_parameters.keys()

				for i in range(parameters.size()):
					var p = parameters[keys[i]]
					var hi_p = hi_parameters[hi_keys[i]]

					if p != hi_p:
						return false

	return true

func can_auto() -> bool:
	return current_statement.type in skip_types

func can_skip() -> bool:
	var seen = is_current_statement_in_global_history()
	return can_auto() and seen

func can_qload() -> bool:
	return is_save_exits("quick")

func is_save_exits(save_name:String) -> bool:
	loading_in_progress = true
	var save_folder_path = "usr://".plus_file(save_folder)

	if test_save:
		save_folder_path = "res://".plus_file(save_folder)

	var save_file_path = save_folder_path.plus_file(save_name)
	save_file_path += ".tres"

	return file.file_exists(save_file_path)

func save_global_history() -> bool:
	return $SaveGlobalHistory.invoke()

func load_global_history() -> bool:
	return $LoadGlobalHistory.invoke()
