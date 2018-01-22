## This is Ren API ##
## version: 0.3.0 ##
## License MIT ##
## Ren GDScript passer class ##

extends Node

func gds_rex(code, before_value, after_value, values):
	var  replacement = "ren\\.values\\." + before_value + "\\.value" + after_value
	return code.replace('(^|\\s)' + before_value + after_value + '($|\\s)', replacement)

func gds_func_rex(code, before_value, values):
	var  replacement = "call\\(ren\\.values\\." + before_value + "\\.value\\)"
	return code.replace('(^|\\s)' + before_value + '($|\\s)', replacement)

func gds_passer(code, values):

	if code != "":

		for val_name in values.keys():
			
			var val_type = values[val_name].type

			if val_type in ["text", "var"]:
				code = gds_rex(code, val_name, "", values)
			
#			elif val_type == "func":
#				code = code_rex(code, val_name, "\\(.*\\)", values)
				
			elif val_type in ["dict", "character"]:
				code = gds_rex(code, val_name, "", values)
				code = gds_rex(code, val_name, "\\.", values)
			
			elif val_type == "list":
				code = gds_rex(code, val_name, "", values)
				code = gds_rex(code, val_name, "\\[\\d\\]", values)
	
	return code