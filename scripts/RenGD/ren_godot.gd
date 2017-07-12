## This is Ren'GD API ##

## version: 0.7 ##
## License MIT ##

extends Node

onready var ren = get_node("/root/Window")
var script_lines = []
var script = """
extends "res://scripts/RenGD/ren_short.gd"
func eval():
"""


func statement(expression):
	## return g/godot statement
	var s = {"type":"godot", "arg":expression}
	return s


func append(expression):
	## append g/godot statement
	var s = statement(expression)
	ren.statement.append(s)


func use(statement):
	## "run" g/godot statement
	var expression = statement.arg
	for key_name in ren.keywords.keys():
		if expression.find(key_name) == -1:
			continue # no keyword in this string
		
		expression = expression.replace(key_name, "ren.keywords." + key_name + ".value")
	
	
	if expression.find("var") != -1:
		var var_name = expression.split("=")[0]
		var_name = var_name.replace("var", "")
		var_name = var_name.replace(" ", "")
		var_name = var_name.replace("\t", "")
		define(var_name)

	# if expression.find("define") != -1:
	# 	var var_name = expression.split("'")[1]
	# 	var_name = var_name.split('"')[1]
	# 	define(var_name)
	
	script_lines.append(expression)

	var nscript = ""
	var s = ren.get_next_statement()
	if s.type != "godot":
		for sl in script_lines:
			sl += "\n\t"
			
			nscript += sl

		exec(nscript)


func exec(expression):
	var gdscript = GDScript.new()
	print(script + "\t" + expression)
	gdscript.set_source_code(script + "\t" + expression)
	gdscript.reload()

	var obj = Node.new() #So we can call get_node
	obj.set_script(gdscript)
	add_child(obj)
	var ret_val = obj.eval()
	remove_child(obj)

	return ret_val



