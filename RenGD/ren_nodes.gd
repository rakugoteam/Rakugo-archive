## This is Ren'GD API ##

## version: 0.1.0 ##
## License MIT ##

extends Object

func node(nodes, ren_name, node, subnode = false):
	## adds node do nodes
	nodes[ren_name] = {"node": node, "sub": subnode}
	node.hide()


func auto_subnodes(nodes, ren_name, node, name_of_node_to_skip = ""):
	## auto adds children of node as node's subnodes
	for n in node.get_children():
		if n.get_name() != name_of_node_to_skip:
			var name = ren_name + " " + n.get_name()
			node(nodes, name, n, true)


func show_statement(nodes, node_to_show):
	## return show statement
	if node_to_show in nodes:
		node_to_show = nodes[node_to_show].node

	var s = {
		"type": "show",
		"arg":{"node": node_to_show}
	}

	return s


func hide_statement(nodes, node_to_hide):
	## return hide statement
	var type = typeof(node_to_hide)
	
	if node_to_hide in nodes:
		node_to_hide = nodes[node_to_hide].node

	var s = {
		"type": "hide",
		"arg":{"node": node_to_hide}
	}

	return s