## This is Ren API ##
## version: 0.3.0 ##
## License MIT ##

extends Node

func define(values, val_name, val_value = null, val_type = null):
	if val_value != null && val_type == null:
		val_type = "var"
		var type = typeof(val_value)

		if type == TYPE_STRING:
			val_type = "text"
		
		elif type == TYPE_DICTIONARY:
			val_type = "dict"
		
		elif type == TYPE_ARRAY:
			val_type = "list"
			print('list are not fully supported by text_passer')
	
	values[val_name] = {"type":val_type, "value":val_value}
