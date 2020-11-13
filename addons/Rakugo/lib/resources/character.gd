extends Resource
class_name Character


export var name:String
export var tag:String
export var color:Color setget _set_color

#Affixies to be used with the character name
export var prefix:String = ""
export var suffix:String = ""

export var show_parameters:Dictionary = {}
export var say_parameters:Dictionary = {}
export var variables:Dictionary = {}

func _init():
	show_parameters = {}
	say_parameters = {}
	variables = {}


func init(_name:String, _tag:String, _color="ffffff"):
	name = _name
	tag = _tag
	color = _color
	return self


func _get(property):
	if property in self.get_property_list():
		return self[property]
	elif self.variables.has(property):
		return self.variables[property]
	return null


func _set(property, value):
	if property in self.get_property_list():
		self[property] = value
	else:
		self.variables[property] = value
	return true


func duplicate(_deep:bool=true) -> Resource:##Store duplication should always be deep
	var output = .duplicate(true)
	output.script = self.script
	return output


func _set_color(_color) -> void:## That setter is to convert potential color given in string or int
	if _color is Color:
		color = Color(_color.r, _color.g, _color.b, _color.a)
	else:
		color = Color(color)


func apply_default(input:Dictionary, default:Dictionary):
	var output = input.duplicate()
	for k in default.keys():
		if not output.has(k):
			output[k] = default[k]
	return output

func get_composite_name(_markup_override="", _affixes=true) -> String:
	var composite_name = ""

	if name != "":
		if _affixes:
			composite_name = prefix + name + suffix
		else:
			composite_name = name
		if _markup_override == "bbcode" or Rakugo.markup == "bbcode":
			composite_name = "[color=#%s]%s[/color]" % [color.to_html(), composite_name]
		elif _markup_override == "renpy" or Rakugo.markup == "renpy":
			composite_name = "{color=#%s}%s{/color}" % [color.to_html(), composite_name]

	return composite_name

## Dialogue shorts (to be shielded behind a getter in Dialogue)

func say(text:String, parameters:Dictionary = {}) -> void:
	Rakugo.say(self, text, parameters)


func show(parameters:Dictionary = {}) -> void:
	apply_default(parameters, self.show_parameters)
	Rakugo.show(self.tag, parameters)#TODO will have to take a look at how it should work with the rules of showing. Maybe add some functionality.


func hide() -> void:
	Rakugo.hide(self.tag) #TODO, will have to take a look at how it should work with the rules of hiding
