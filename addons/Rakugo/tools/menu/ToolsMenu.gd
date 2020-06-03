tool
extends MenuButton

func _ready() -> void:
	var docs_icon := get_icon("Help", "EditorIcons")
	get_popup().set_item_icon(2, docs_icon)

	get_popup().connect("id_pressed", self, "_on_id")


func _on_id(id:int) -> void:
	match id:
		# Emoji Panel
		0:
			$C/EmojiPopup.popup_centered()

		# SceneLinks Tool
		1:
			$C/ScenesLinksManager.popup_centered()

		# Rakugo Docs
		2:
			OS.shell_open("https://rakugo.readthedocs.io/en/latest/")

		# About Rakugo
		3:
			$C/AboutDialog.popup_centered()

		# Rakugo Website:
		4:
			OS.shell_open("https://rakugoteam.github.io/")
