## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.7 ##
## License MIT ##

extends Object

func node(nodes, ren_name, value):
    ## adds node do nodes
    nodes[ren_name] = value
    value.hide()


func show_statement(nodes, node_to_show):
    ## return show statement
    if node_to_show in nodes:
        node_to_show = nodes[node_to_show]

    var s = {
        "type": "show",
        "arg":
            {
			"node": node_to_show
            }
    }

    return s


func hide_statement(nodes, node_to_hide):
    ## return hide statement
    var type = typeof(node_to_hide)
    
    if node_to_hide in nodes:
        node_to_hide = nodes[node_to_hide]

    var s = {
        "type": "hide",
        "arg":
            {
			"node": node_to_hide
            }
    }

    return s