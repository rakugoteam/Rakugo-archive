extends "statement.gd"

func _init():
	._init()
	type = "notify"
	kws = ['info', 'lenght']
	kwargs['info'] = ""
	kwargs['length'] = 1

func exec(dbg = true):
	if "info" in kwargs:
		kwargs.info = Ren.text_passer(kwargs.info)
	
	.exec(dbg)

