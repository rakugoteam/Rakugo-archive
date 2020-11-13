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
		
		# Open Rakugo Docs
		2:
			OS.shell_open("https://rakugoteam.github.io/RakugoDocs-new/")
		
		# About Rakugo
		3:
			$AboutDialog.popup_centered()
