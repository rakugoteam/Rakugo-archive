## This is Ren API ##

## version: 0.1.0 ##
## License MIT ##

extends Object

###						###
###	Character	import	###
###						###

const REN_CH = preload("character.gd")
onready var ren_ch = REN_CH.new()

func define(values, val_name, val_value = null):
	## add global var that ren will see
	var val_type = "var"

	if val_value != null:
		var type = typeof(val_value)

		if type == TYPE_STRING:
			val_type = "text"
		
		elif type == TYPE_DICTIONARY:
			val_type = "dict"
		
		elif type == typeof(ren_ch):
			val_type = "Character"
		
		elif type == TYPE_ARRAY:
			val_type = "list"
			print('list are not fully supported by text_passer')
		
	
	values[val_name] = {"type":val_type, "value":val_value}
