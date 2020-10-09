extends Panel

var entry:HistoryEntry

func init():
	if entry.character:
		$VBox/CharacterName.bbcode_text = entry.character.name
	else:
		$VBox/CharacterName.bbcode_text = Rakugo.Say.get_narrator().name
	$VBox/Text.bbcode_text = entry.text
