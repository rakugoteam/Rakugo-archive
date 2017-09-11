## This is Ren'GD API ##

## version: 0.1.0 ##
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
	return {"type":"godot", "arg":expression}


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
	if s.type != "godot":
		for sl in script_lines:
			sl += "\n\t"
			
			nscript += sl

		exec(nscript)
		ren.next_statement()


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
	return {"type":"if", "arg":expression}


func elif_statement(expression):
	## return elif statement
	return {"type":"elif", "arg":expression}


func else_statement():
	## return else statement
	return {"type":"else", "arg":"true"}


func end_statement():
	## return end statement
	return {"type":"end", "arg":"true"}

var current_condition 

func use_condition(statement, statements, snum):
	var statements_after = ren.array_slice(statements, snum+1, statements.size())
	print(statements_after)
	current_condition = statement.arg
	if exec(current_condition):
		ren.next_statement()	

	else:
		var i = ren.find_statement_of_type(statements_after, ["else", "end", "elif"])
		
		if i > -1:
			ren.use_statement(snum + i)
		else:
			print("no alternative or end for condition : ", current_condition)

