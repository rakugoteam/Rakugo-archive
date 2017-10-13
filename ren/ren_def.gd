## This is Ren'GD API ##

## version: 0.1.0 ##
## License MIT ##

extends Object

###						###
###	Character	import	###
###						###

const REN_CH = preload("character.gd")
onready var ren_ch = REN_CH.new()

func define(keywords, key_name, key_value = null):
	## add global var that ren will see
	var key_type = "var"

	if key_value != null:
		var type = typeof(key_value)

		if type == TYPE_STRING:
			key_type = "text"
		
		elif type == TYPE_DICTIONARY:
			key_type = "dict"
		
		elif type == typeof(ren_ch):
			key_type = "Character"
		
		elif type == TYPE_ARRAY:
			key_type = "list"
			print('list are not fully supported by text_passer')
		
	
	keywords[key_name] = {"type":key_type, "value":key_value}
