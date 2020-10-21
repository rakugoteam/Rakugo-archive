extends RichTextLabel

export (String, MULTILINE) var markdown = ""

func _ready() -> void:
	bbcode_enabled = true
	Rakugo.connect("started", self, "_on_rakugo")

func _on_rakugo():
	bbcode_text = Rakugo.TextParser.convert_markdown_markup(markdown)
	print(bbcode_text)
