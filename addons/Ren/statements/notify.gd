extends "statement.gd"

func _init():
	._init()
	type = "notify"
	kws = ['info']

func exec(dbg = true):
	if "info" in kwargs:
		kwargs.info = Ren.text_passer(kwargs.info)
	
	.exec(dbg)

