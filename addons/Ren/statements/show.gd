extends Statement
class_name Show

func _init() -> void:
	._init()
	type = 4 # Ren.StatementType.SHOW
	kws = ["node_id", "state", "x", "y", "z", "at", "pos"]

func exec(dbg = true) -> void:
	if dbg:
		debug(kws)
	
	if "at" in kwargs:
		if "center" in kwargs.at:
			kwargs["x"] = 0.5
			
		if "left" in kwargs.at:
			kwargs["x"] = 0.0

		if "right" in kwargs.at:
			kwargs["x"] = 1.0

	if "at" in kwargs:
		if "center" in kwargs.at:
			kwargs["y"] = 0.5
			
		if "top" in kwargs.at:
			kwargs["y"] = 0.0

		if "bottom" in kwargs.at:
			kwargs["y"] = 1.0
	
	Ren.on_show(kwargs.node_id, kwargs.state, kwargs)



