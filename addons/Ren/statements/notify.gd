extends "statement.gd"

func _init():
	type = "notify"
	kws = ['info']

func exec(dbg = true):
	.exec(dbg)
	
	if "info" in kwargs:
		kwargs.info = Ren.text_passer(kwargs.info)
	
