extends "statement.gd"

var func_name
var node
var args = []

func _init(_node, _func_name, _args = []):
	func_name = _func_name
	node = _node
	args = _args
	type = "func"

func enter(dbg = true):
	.enter(dbg)
	node.callv(func_name, args)
	on_exit()

