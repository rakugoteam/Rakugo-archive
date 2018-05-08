extends "statement.gd"

func _init():
	type = "jump"
	kws = ["dialog"]

func exec(dbg = true):
	.exec(true)
	Ren.timer.start()
	
func on_exit(_type, new_kwargs = {}):
	if _type != type:
		return
		
	.on_exit(_type, new_kwargs)
	Ren.jump_to(kwargs.dialog_name)
