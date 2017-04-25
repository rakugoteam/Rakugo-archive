extends Control

onready var  ren = get_node("/root/Window")

func start_ren():
    ## This must be at end of code using ren api
	## this start ren "magic" ;)
	ren.start_ren()


func define(key_name, key_value = null):
    ## add global var that ren will see
    ren.define(key_name, key_value)


func Character(name="", color="", what_prefix="", what_suffix="", kind="adv"):
    ## return new Character
    return ren.Character(name, color, what_prefix, what_suffix, kind)


func auto_Character(name="", color="", what_prefix="", what_suffix="", kind="adv"):
    ## add global new Character auto assain to var 'name' 
	var ch = ren.Character(name, color, what_prefix, what_suffix, kind)
	ren.define(name, ch)


func say(how, what):
 	## append say statement
	ren.append_say(how, what)


func input(ivar, what, temp = ""):
	## append input statement
	ren.append_input(ivar, what, temp)


func before_menu():
    ## must be on begin of menu custom func
    ren.before_menu()


func menu_statement(choices, title, node = null, func_name = null):
	## return custom menu statement
    ren.menu(choices, title, node, func_name)


func after_menu():
	## must be on end of menu custom func
    ren.after_menu()


func label(label_name, scene_path, node_path = null, func_name = null):
    ## this declare new label
    ## that make ren see label and can jump to it
	ren.label(label_name, scene_path, node_path, func_name)