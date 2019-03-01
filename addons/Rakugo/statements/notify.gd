extends Statement
class_name Notify

func _init() -> void:
	._init()
	type = 6 # Rakugo.StatementType.NOTIFY
	parameters_names = ['info', 'lenght']
	parameters['info'] = ""
	parameters['length'] = 1

func exec() -> void:
	debug(parameters_names)
	
	if "info" in parameters:
		parameters.info = Rakugo.text_passer(parameters.info)

	.exec()
