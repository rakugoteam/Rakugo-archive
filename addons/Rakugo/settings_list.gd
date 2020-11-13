extends Object
class_name SettingsList

var default_property_list:Dictionary = {
	"rakugo/game/info/version" : [
		"0.0.1", PropertyInfo.new(
			"", TYPE_STRING, PROPERTY_HINT_NONE, 
			"", PROPERTY_USAGE_DEFAULT)
	],

	
	"rakugo/game/info/credits" : [
		"Your Company", PropertyInfo.new(
			"", TYPE_STRING, PROPERTY_HINT_MULTILINE_TEXT, 
			"", PROPERTY_USAGE_DEFAULT)
	],

	
	"rakugo/game/scenes/scene_links" : [
		"res://game/scene_links.tres", PropertyInfo.new(
			"", TYPE_STRING, PROPERTY_HINT_FILE, 
			"*.tres", PROPERTY_USAGE_DEFAULT)
	],
	
	
	"rakugo/game/scenes/force_reload" : [
		false, PropertyInfo.new(
			"", TYPE_BOOL, PROPERTY_HINT_NONE, 
			"", PROPERTY_USAGE_EDITOR)
	],

	
	"rakugo/game/store/rollback_steps" : [
		10, PropertyInfo.new(
			"", TYPE_INT, PROPERTY_HINT_NONE, 
			"", PROPERTY_USAGE_DEFAULT)
	],

	
	"rakugo/game/store/history_length" : [
		30, PropertyInfo.new(
			"", TYPE_INT, PROPERTY_HINT_NONE, 
			"", PROPERTY_USAGE_DEFAULT)
	],

	
	"rakugo/game/text/markup" : [
		"renpy", PropertyInfo.new(
			"", TYPE_STRING, PROPERTY_HINT_ENUM, 
			"renpy,bbcode,markdown,markdown_simple", PROPERTY_USAGE_CATEGORY)
	],


	"rakugo/default/narrator/name" : [
		"Narrator", PropertyInfo.new(
			"", TYPE_STRING, PROPERTY_HINT_NONE, 
			"", PROPERTY_USAGE_DEFAULT)
	],


	"rakugo/default/narrator/color" : [
		Color.white, PropertyInfo.new(
			"", TYPE_COLOR, PROPERTY_HINT_NONE, 
			"", PROPERTY_USAGE_DEFAULT)
	],


	"rakugo/default/gui/theme" : [
		"res://themes/Default/default.tres",
		PropertyInfo.new(
			"", TYPE_STRING, PROPERTY_HINT_FILE, 
			"*.tres", PROPERTY_USAGE_DEFAULT)
	],


	"rakugo/default/delays/typing_effect_delay" : [
		0.1, PropertyInfo.new(
			"", TYPE_REAL, PROPERTY_HINT_EXP_RANGE, 
			"0.005, 1.0,or_greater", PROPERTY_USAGE_DEFAULT)
	],


	"rakugo/default/delays/typing_effect_punctuation_factor" : [
		4.0, PropertyInfo.new(
			"", TYPE_REAL, PROPERTY_HINT_EXP_RANGE, 
			"0.1, 5.0,or_greater", PROPERTY_USAGE_DEFAULT)
	],


	"rakugo/default/delays/auto_mode_delay" : [
		3, PropertyInfo.new(
			"", TYPE_REAL, PROPERTY_HINT_RANGE, 
			"0.1, 10.0", PROPERTY_USAGE_DEFAULT)
	],


	"rakugo/default/delays/skip_delay" : [
		0.1, PropertyInfo.new(
			"", TYPE_REAL, PROPERTY_HINT_EXP_RANGE, 
			"0.0, 2.0", PROPERTY_USAGE_DEFAULT)
	],


	"rakugo/default/statements/default_say_parameters" : [
		{}, PropertyInfo.new(
			"", TYPE_DICTIONARY, PROPERTY_HINT_NONE, 
			"", PROPERTY_USAGE_EDITOR)
	],


	"rakugo/default/statements/default_ask_parameters" : [
		{}, PropertyInfo.new(
			"", TYPE_DICTIONARY, PROPERTY_HINT_NONE, 
			"", PROPERTY_USAGE_EDITOR)
	],


	"rakugo/default/statements/default_show_parameters" : [
		{}, PropertyInfo.new(
			"", TYPE_DICTIONARY, PROPERTY_HINT_NONE, 
			"", PROPERTY_USAGE_EDITOR)
	],


	"rakugo/editor/debug" : [
		false, PropertyInfo.new(
			"", TYPE_BOOL, PROPERTY_HINT_NONE, 
			"", PROPERTY_USAGE_EDITOR)
	],


	"rakugo/saves/save_folder" : [
		"res://saves", PropertyInfo.new(
			"", TYPE_STRING, PROPERTY_HINT_DIR, 
			"", PROPERTY_USAGE_DEFAULT)
	],


	"rakugo/saves/save_screen_layout" : [
		"save_pages", PropertyInfo.new(
			"", TYPE_STRING, PROPERTY_HINT_ENUM, 
			"save_pages,save_list", PROPERTY_USAGE_DEFAULT)
	],


	"rakugo/saves/test_mode" : [
		true, PropertyInfo.new(
			"", TYPE_BOOL, PROPERTY_HINT_NONE, 
			"", PROPERTY_USAGE_EDITOR)
	],


	"rakugo/saves/saved_rollback_steps" : [
		10, PropertyInfo.new(
			"", TYPE_INT, PROPERTY_HINT_NONE, 
			"", PROPERTY_USAGE_DEFAULT)
	],
}
