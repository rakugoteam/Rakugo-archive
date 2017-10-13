## This is Ren'GD API ##

## version: 0.1.0 ##
## License MIT ##
## Character Class ##

extends Node

var name = ""
var color = ""
var what_prefix = ""
var what_suffix = ""
var kind = ""

func _init(name="", color="", what_prefix="", what_suffix="", kind="adv"):
	## return new Character
	self.name = name
	self.color = color
	self.what_prefix = what_prefix
	self.what_suffix = what_suffix
	self.kind = kind

func parse_character(vars):
	var ncharacter= ""
	
	if self.name != ("" or null):
		ncharacter= "{color=" + self.color + "}"
		ncharacter+= self.name
		ncharacter+= "{/color}"
		
		ncharacter = text_passer(ncharacter, vars)
	
	return ncharacter

func parse_what(what):
	 return what_prefix + what + what_suffix

