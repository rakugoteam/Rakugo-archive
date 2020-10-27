tool
extends Label


func _on_emoji_selected(emoji_name, emoji_code):
	self.text = "%s (%s) copied" % [emoji_name, emoji_code]
	$Timer.start(2)


func _on_timeout():
	self.text = ""
