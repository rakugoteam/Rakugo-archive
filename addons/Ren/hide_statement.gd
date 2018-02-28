## This is Ren API ##
## version: 0.5.0 ##
## License MIT ##
## Hide Node statement class ##

extends "statement.gd"
var _node

func _init(node):
	type = "hide"
	_node = node

func enter(dbg = true):
	if dbg:
		print(debug(kws))

	var xnode = ren.values[_node].value
	if xnode.visible:
		xnode.hide()
		
	.enter(false)
	on_exit()
