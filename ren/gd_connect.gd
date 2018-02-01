## This is Ren API ##
## version: 0.3.0 ##
## License MIT ##
## Ren <-> Godot code connection class ##

extends Node

onready var ren	= get_node("/root/Window")

const _GDS = preload("gds_passer.gd")
var gds = _GDS.new()
var n = Node.new()
var gdscript = GDScript.new()

func exec(code):
	code = gds.gds_passer(code, ren.values)

	var script = "extends Node\n"
	script += "onready var ren = get_node('/root/Window')\n"
	script += "func exec():\n"
	script += "\treturn " + code
	
	# print(script)
	n = Node.new()
	gdscript = GDScript.new()
	gdscript.set_source_code(script)
	gdscript.reload()
	n.set_script(gdscript)
	add_child(n)
	var ret_val = n.exec()
	remove_child(n)
	return ret_val

