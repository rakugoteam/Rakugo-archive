## This is RenAPI ##
## version: 0.5.0 ##
## License MIT ##
## Notify statement class ##

extends "statement.gd"

func _init():
	type = "notify"
	kws = ['info']

func enter(dbg = true):
	if dbg:
		print(debug(kws))
	
	if "info" in kwargs:
		kwargs.info = text_passer(kwargs.info)
	
	.enter(false)
	.on_exit({})

