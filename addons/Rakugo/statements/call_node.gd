extends Statement
class_name CallNode

func _init() -> void:
	._init()
	type = 11 # Rakugo.StatementType.CALL_NODE
	parameters_names = ["node_id", "func_name", "args"]
	parameters["node_id"] = ""
	parameters["func_name"] = ""
	parameters["args"] = []

func exec() -> void:
	var n = Rakugo.get_node_value(parameters.node_id)
	
	if not n:
		prints(parameters.node_id, "can't be find")
		return
	
	var node_path = n["node_path"]
	var node = Rakugo.get_node(node_path)
	
	if  not node:
		prints(parameters.node_id, "can't be find")
		return

	node.callv(parameters.func_name, parameters.args)
	.exec()
