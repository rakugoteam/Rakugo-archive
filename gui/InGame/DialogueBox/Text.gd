extends RichTextLabel

func _ready():
	Rakugo.connect("say" ,self, "_on_say")


func _on_say(_character, _text, _parameters):
	self.visible_characters = -1
	self.bbcode_text = _text
	if true or _parameters.get('typing'):
		simulate_typing()

func simulate_typing():
	self.visible_characters = 0
	
	var regex = RegEx.new()
	regex.compile("[[:graph:]]")
	
	for ch in self.text:
		self.visible_characters += 1
		if regex.search(ch):
			print("printable '", ch, "'")
			if ch in ",;.!?":
				$TypingTimer.start(float(ProjectSettings.get_setting("application/rakugo/punctuation_pause")))
			else:
				$TypingTimer.start(0.1)
			yield($TypingTimer, "timeout")
			$TypingTimer.set_wait_time(0.1)
	$TypingTimer.stop()
