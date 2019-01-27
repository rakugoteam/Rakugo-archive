extends Statement
class_name Notify

func _init() -> void:
	._init()
	type = 6 # Ren.StatementType.NOTIFY
	parameters_names = ['info', 'lenght']
	parameters['info'] = ""
	parameters['length'] = 1

func exec(dbg : bool = true) -> void:
	if "info" in parameters:
		parameters.info = Ren.text_passer(parameters.info)
		
	if dbg: # for some strage reason .exec(dbg) give error
		.exec()

