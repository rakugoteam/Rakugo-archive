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
		
		# About Rakugo
		5:
			$AboutDialog.popup_centered()
