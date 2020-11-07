extends PanelContainer

func init(entry):
	if entry.character_tag and Rakugo.store.get(entry.character_tag):
		$VBoxContainer/CharacterName.bbcode_text = Rakugo.store.get(entry.character_tag).get_composite_name('bbcode')
	else:
		$VBoxContainer/CharacterName.bbcode_text = Rakugo.Say.get_narrator().get_composite_name('bbcode')
	if not $VBoxContainer/CharacterName.text:
		$VBoxContainer/CharacterName.visible = false
	$VBoxContainer/Text.bbcode_text = entry.text
