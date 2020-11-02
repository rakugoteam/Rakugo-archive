extends LineEdit

var variable_name:String = ""

func _ready():
	Rakugo.connect("ask" ,self, "_on_ask")


func _on_ask(default_answer, _parameters):
	if _parameters.has('placeholder'):
		self.placeholder_text = _parameters['placeholder']
	self.text = default_answer
	show()


func _on_text_entered(new_text):
	hide()
	Rakugo.ask_return(new_text)
