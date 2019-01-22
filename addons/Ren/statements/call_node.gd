extends Statement
class_name CallNode

func _init():
	._init()
	type = 11 # Ren.StatementType.CALL_NODE
	kws = ["node_id", "func_name", "args"]
	kwargs["node_id"] = ""
	kwargs["func_name"] = ""
	kwargs["args"] = []

func exec(dbg = true):
	var node = Ren.get_node_by_id(kwargs.node_id)
	if node == null:
		prints(kwargs.node_id, "can't be find")
		return
		
	node.callv(kwargs.func_name, kwargs.args)
	.exec(dbg)
