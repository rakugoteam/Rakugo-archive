extends LineEdit

var variable_name:String = ""

func _ready():
	Rakugo.connect("ask" ,self, "_on_ask")


func _on_ask(_variable_name, _parameters):
	if _parameters.has('placeholder'):
		self.placeholder_text = _parameters['placeholder']
	elif Rakugo.get_current_store().get(_variable_name):
		self.text = Rakugo.get_current_store().get(variable_name)
	variable_name = _variable_name
	show()


func _on_text_entered(new_text):
	hide()
	Rakugo.get_current_store()[variable_name] = new_text
	Rakugo.story_step()
