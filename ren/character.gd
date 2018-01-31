## This is Ren API ##
## version: 0.3.0 ##
## License MIT ##
## Character Class ##

extends Node

var kwargs = {"kind":"adv", "what_prefix":"", "what_suffix":"", "color":"white"}
var kw = ["name", "color", "what_prefix", "what_suffix", "kind", "avatar"]

func set_kwargs(new_kwargs):
	# update character
	for kw in new_kwargs:
		kwargs[kw] = new_kwargs[kw]

func parse_character():
	var ncharacter = ""
	
	if "name" in kwargs:
		ncharacter = "{color=" + kwargs.color + "}"
		ncharacter += kwargs.name
		ncharacter += "{/color}"
	
	return ncharacter

func parse_what(what):
	 return kwargs.what_prefix + what + kwargs.what_suffix

