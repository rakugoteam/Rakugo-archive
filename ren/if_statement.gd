## This is Ren API ##
## version: 0.3.0 ##
## License MIT ##
## if class statement ##

extends "statement.gd"

const _GDS = preload("gds_passer.gd")
var gds = _GDS.new()
var n = Node.new()
var gdscript = GDScript.new()

var statements = []
var condition = ""
var conditions = []
var el = null

func _init(_condition=""):
	type = "if"
	condition = _condition

func enter(dbg = true): 
	if dbg:
		print(debug(kws))
	
	ren.current_statement_id = id
	ren.current_block = self

	on_enter_block({})

func on_enter_block(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	if exec(condition):
		statements[0].enter()
		return
	
	elif conditions.size() > 0:
		for c in conditions:
			if exec(c):
				c.statements[0].enter()
				break
	
	elif el != null:
		el.statements[0].enter()

func exec(code):
	code = gds.gds_passer(code, ren.values)

	var script = "extends Node\n"
	script += "onready var ren = get_node('/root/Window')\n"
	script += "func exec():\n"
	script += "\treturn " + code

	gdscript.set_source_code(script)
	gdscript.reload()
	n.set_script(gdscript)
	return n.exec()



