extends Node

func gds_rex(code, before_value, after_value, values):
	var replacement = "Ren.values." + before_value + ".value" + after_value
	var rex = RegEx.new()
	rex.compile('(^|\\s)' + before_value + after_value + '($|\\s)')
	return rex.sub(code, replacement, true)


func gds_passer(code, values):

	if code != "":

		for val_name in values.keys():
			
			var val_type = values[val_name].type

			if val_type in ["text", "var"]:
				code = gds_rex(code, val_name, "", values)
				
			elif val_type in ["dict", "character"]:
				code = gds_rex(code, val_name, "", values)
				code = gds_rex(code, val_name, "\\.", values)
			
			elif val_type == "list":
				code = gds_rex(code, val_name, "", values)
				code = gds_rex(code, val_name, "\\[\\d\\]", values)
	
	return code