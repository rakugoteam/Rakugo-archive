tool
extends Control

func _on_menu(id:int) -> void:
	match id:
		# Emoji Panel
		0:
			$EmojiPopup.popup_centered()

		# ScenesLinks Tool
		1:
			$SceneLinksEditor.popup_centered()

		# Rakugo Docs
		2:
			OS.shell_open("https://rakugo.readthedocs.io/en/latest/")

		# About Rakugo
		3:
			$AboutDialog.popup_centered()

		# Rakugo Website:
		4:
			OS.shell_open("https://rakugoteam.github.io/")
