## This is Ren API ##

## version: 0.1.0 ##
## License MIT ##
## Character Class ##

extends Node

var kwargs = {"kind":"adv"}
var kw = ["name", "color", "what_prefix", "what_sufifx", "kind", "avatar"]

func set_kwargs(new_kwargs):
	# update character
	for kw in kwargs:
		if kw in new_kwargs:
			kwargs[kw] = new_kwargs[kw]

func parse_character(vars):
	var ncharacter= ""
	
	if "name" in kwargs:
		ncharacter= "{color=" + kwargs.color + "}"
		ncharacter+= kwargs.name
		ncharacter+= "{/color}"
		
		ncharacter = text_passer(ncharacter, vars)
	
	return ncharacter

func parse_what(what):
	 return kwargs.what_prefix + what + kwargs.what_suffix

