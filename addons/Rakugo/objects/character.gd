extends Resource
class_name Character


var name:String
var tag:String
var color:Color setget _set_color

#Affixies to be used with the character name
var prefix:String = ""
var suffix:String = ""

var show_parameters:Dictionary = {}
var say_parameters:Dictionary = {}
var variables:Dictionary = {}



func _init(_name:String, _tag:String, _color="ffffff"):
	name = _name
	tag = _tag
	color = _color


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


func _set_color(_color) -> void:## That setter is to convert potential color given in string or int
	color = Color(color)


func apply_default(input:Dictionary, default:Dictionary):
	var output = input.duplicate()
	for k in default.keys():
		if not output.has(k):
			output[k] = default[k]
	return output

func get_composite_name(_affixes=true) -> String:
	var composite_name = ""

	if name != "":
		if _affixes:
			composite_name = prefix + name + suffix
		else:
			composite_name = name
		if Rakugo.markup == "bbcode":
			composite_name = "[color=#%s]%s[/color]" % [color.to_html(), composite_name]
		elif Rakugo.markup == "renpy":
			composite_name = "{color=#%s}%s{/color}" % [color.to_html(), composite_name]

	return composite_name

## Dialogue shorts (to be shielded behind a getter in Dialogue)

func say(text:String, parameters:Dictionary = {}) -> void:
	Rakugo.say(self, text, parameters)


func ask(text:String, parameters:Dictionary = {}) -> void:
	Rakugo.ask(self, text, parameters)


func show(parameters:Dictionary = {}) -> void:
	apply_default(parameters, self.show_parameters)
	Rakugo.show(self.tag, parameters)#TODO will have to take a look at how it should work with the rules of showing. Maybe add some functionality.


func hide() -> void:
	Rakugo.hide(self.tag) #TODO, will have to take a look at how it should work with the rules of hiding
