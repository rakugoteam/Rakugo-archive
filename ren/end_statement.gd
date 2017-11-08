## This is RenAPI ##

## version: 0.2.0 ##
## License MIT ##
## End class statement ##

extends "statement.gd"

var indentation_delta

func _init(_indentation_delta = 1):
	indentation_delta = _indentation_delta
	type = "end"

func ren_init():
	check_indentation()
	
	if ren.current_block_type == "menu":
		ren.current_menu = null
	
	end_block = ren.current_block_type
	ren.current_block_type = ren.previous_block_type

func check_indentation():
	if ren.current_indentation < 1:
		print("Error: Wrong indentation ", indentation, ", current ", ren.current_indentation)
		return
	
	ren.current_indentation -= indentation_delta
	
func enter(dbg = true, new_kwargs = {}):
	if dbg:
		debug(kws)
	
	on_exit(new_kwargs)

func on_exit(new_kwargs = {}):
	var next_sid = find_next()
	
	if ren.current_indentation > 0:
		if next_sid > -1:
			while ren.statements[next_sid].type != "end":
				next_sid = find_next(next_sid)
			
			ren.statements[next_sid].debug()
			if end_block == "choice":
				while ren.statements[next_sid].end_block != "menu":
					next_sid = find_next(next_sid)
	
	elif next_sid > -1:
		ren.statements[next_sid].enter()
	
	else:
		print("End of Label")

func debug(kws = [], some_custom_text = ""):
	.debug(kws, some_custom_text + "indentation_delta : " + str(indentation_delta) + ", end_block : " + end_block)