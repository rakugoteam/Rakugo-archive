## This is RenAPI ##

## version: 0.2.0 ##
## License MIT ##
## Choice class statement ##

extends "statement.gd"


func _init():
	type = "choice"
	kws = ["how", "what"]

func ren_init():
	if ren.current_menu != null:
		ren.current_menu.choices[kwargs.what] = id
		print("current menu", ren.current_menu, "added choice : ", kwargs.what, " : ", id)
	
	else:
		print("Error: choice statement out side menu ", debug(kws))
		return
	
	check_indentation()

func check_indentation():
	if not ren.using_passer:
		ren.current_indentation += 1
	
	else:
		ren.current_indentation = indentation

func enter(dbg = true, new_kwargs = {}):
	if dbg:
		debug(kws)
	
	on_exit(new_kwargs)