extends PanelContainer

func init(entry):
	if entry.character:
		$VBoxContainer/CharacterName.bbcode_text = entry.character.get_composite_name('bbcode')
	else:
		$VBoxContainer/CharacterName.bbcode_text = Rakugo.Say.get_narrator().get_composite_name('bbcode')
	if not $VBoxContainer/CharacterName.text:
		$VBoxContainer/CharacterName.visible = false
	$VBoxContainer/Text.bbcode_text = entry.text
