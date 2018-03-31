extends "gd_statement.gd"

var node_path = ""
var func_name = ""
var args = []

func _init(node, func_name, args = []):
	self.node_path = node.get_path()
	self.func_name = func_name
	self.args = args
	type = "func_call"
	code = "get_node('" + node_path + "')"
	code += "." + func_name + "("

	if args.size() > 1:
		for arg in args:
			code += var2str(arg) + ", "
	
	elif args.size() == 1:
		code += var2str(args[0])
	
	code += ")"