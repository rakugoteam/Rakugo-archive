## This is Ren API ##

## version: 0.2.0 ##
## License MIT ##
## Menu class statement ##

extends "say_statement.gd"

var title
var choices = {} # dict of "choice":statment_id
var ids = []
var choices_labels = []

func _init(_title = null):
	._init()
	title = _title 
	type = "menu"

func check_indentation():
	if not ren.using_passer:
		ren.current_indentation += 1
	
	else:
		ren.current_indentation = indentation

func ren_init():
	if title != null:
		ren.define(title, self, "menu")
		
	ren.current_menu = self
	check_indentation()
	ren.current_block_type = "menu"
	
func enter(dbg = true, new_kwargs = {}):	
	if not _init_enter(dbg, new_kwargs):
		return
	
	ren.current_menu = self
	ren.current_block_type = "menu"

	ids = choices.values()
	ids.sort()
	choices_labels = []
	for id in ids:
		for ch in choices:
			# print("choices[ch] != id , : ", choices[ch] != id)
			if choices[ch] != id:
				continue
			
			var l = text_passer(ch)
			choices_labels.append(l)
			break
	
	.enter(false)

func on_exit(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	if "final_choice" in kwargs:
		ren.disconnect("exit_statement", self, "on_exit")
		ren.statements[kwargs.final_choice].enter()
	
	else:
		print("no final_choice recived")
		return

	.on_exit({})