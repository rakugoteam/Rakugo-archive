extends Node

const _GDS = preload("gds_passer.gd")
var gds = _GDS.new()
var n = null
var gdscript = null

## execute gdscript code with Ren tricks
## possible types: "code", "return", "code_block"
func exec(code, type = "return"):
	code = gds.gds_passer(code, Ren.values)

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

