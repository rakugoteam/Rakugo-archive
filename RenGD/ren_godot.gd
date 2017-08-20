## This is Ren'GD API ##

## version: 0.7 ##
## License MIT ##

extends Node

onready var ren = get_node("/root/Window")
var script_lines = []
var script = """
extends "res://RenGD/ren_short.gd"
func eval():
"""

## Base statements: ##
func statement(expression):
	## return g/godot statement
	var s = {"type":"godot", "arg":expression}
	return s


func use(statement):
	## "run" g/godot statement
	var expression = statement.arg
	for var_name in ren.vars.keys():
		if expression.find(var_name) == -1:
			continue # no keyword in this string
		
		expression = expression.replace(var_name, "ren.vars." + var_name + ".value")
	
	
	if expression.find("var") != -1:
		var var_name = expression.split("=")[0]
		var_name = var_name.replace("var", "")
		var_name = var_name.replace(" ", "")
		var_name = var_name.replace("\t", "")
		ren.define(var_name)
	
	script_lines.append(expression)

	var nscript = ""
	var s = ren.get_next_statement()
	if statement.type != "godot":
		for sl in script_lines:
			sl += "\n\t"
			
			nscript += sl

		exec(nscript)


func exec(expression):
	var gdscript = GDScript.new()
	print(script + "\t" + expression)
	gdscript.set_source_code(script + "\t" + expression)
	gdscript.reload()

	var obj = Node.new() # So we can call get_node
	obj.set_script(gdscript)
	add_child(obj)
	var ret_val = obj.eval()
	remove_child(obj)

	return ret_val



func if_statement(expression):
	## return if statement
	var s = {"type":"if", "arg":expression}
	return s


func elif_statement(expression):
	## return elif statement
	var s = {"type":"elif", "arg":expression}
	return s


func else_statement():
	## return else statement
	var s = {"type":"else", "arg":true}
	return s


func end_statement():
	## return end statement
	var s = {"type":"end", "arg":true}
	return s


func use_condition(statement):
	if (statement.type == "if"
		or statement.type == "elif"):
		if exec(statement.arg):
			pass

		else:
			var statements_before_if = ren.array_slice(ren.statements, 0, ren.snum+1)
			var statements_after_if = ren.array_slice(ren.statements, ren.snum+1,
														ren.statements.size()+1)

			var i = 0
			for s in statements_after_if:
				if (statement.type == "else"
					or statement.type == "end"
					or statement.type == "elif"
					):
					statements_after_if = ren.array_slice(ren.statements, i,
															ren.statements.size()+1)
					break

				i+=1
			
			ren.statements = statements_before_if + statements_after_if
	
	elif (statement.type == "else"
		or statement.type == "end"):
		pass

	ren.next_statement()
