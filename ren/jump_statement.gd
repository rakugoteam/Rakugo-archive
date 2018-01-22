# This is Ren API ##
## version: 0.3.0 ##
## License MIT ##
## Jump class statement ##

extends "statement.gd"

func _init():
    type = "jump"
    kws = ["block", "statement_id", "dialog"]

func enter(dbg = true): 
    # todo
    if dbg:
        print(debug(kws))
    
    # todo jump to dialog if in kwagrs
    if "statement_id" in kwargs:
        if "block" in kwargs:
            kwargs.block[kwargs.statement_id].enter()
            # todo elif for types: "if", "elif", "else"
    
        else:
            ren.statements[kwargs.statement_id].enter()

func debug(kws = [], some_custom_text = ""):
	var dbg = str(id) + ":" + type + "(" + some_custom_text
	# dbg += ", block: " + var2str(kwargs.block)
	dbg += ", statement_id: " + str(kwargs.statement_id) + ")"
	print(dbg)