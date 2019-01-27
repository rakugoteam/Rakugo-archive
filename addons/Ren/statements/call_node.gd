extends Statement
class_name CallNode

func _init() -> void:
	._init()
	type = 11 # Ren.StatementType.CALL_NODE
	parameters_names = ["node_id", "func_name", "args"]
	parameters["node_id"] = ""
	parameters["func_name"] = ""
	parameters["args"] = []

func exec(dbg : bool = true) -> void:
	var node = Ren.get_node_by_id(parameters.node_id)
	if node == null:
		prints(parameters.node_id, "can't be find")
		return
		
	node.callv(parameters.func_name, parameters.args)
	.exec(dbg)
