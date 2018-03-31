extends Node

var n = null
var gdscript = null

## execute gdscript code with Ren tricks
## possible types: "code", "return", "code_block"
func exec(code, type = "return"):
	code = gds_passer(code, Ren.values)

	var script = "extends Node\n"
	script += "func exec():\n"

	if type == "return":
		script += "\treturn " + code
	
	elif type == "code":
		script += "\t" + code
	
	elif type == "code_block":
		
		var code_block = code.split("\n")
		
		for c in code_block:
			script += "\t" + c + "\n"
	
	else:
		print("unsupported code")
		return

	# print(script)
	
	n = Node.new()
	gdscript = GDScript.new()
	gdscript.set_source_code(script)
	gdscript.reload()
	n.set_script(gdscript)
	add_child(n)
	var ret_val = n.exec()
	remove_child(n)
	return ret_val

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
