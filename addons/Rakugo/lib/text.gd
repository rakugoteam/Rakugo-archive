tool
extends Node
class_name RakugoTextPasser

var url_open: String = "[color=225ebf][url="
var url_close: String = "[/url][/color]"
var new_line: String = "\n"
var tab: String = "\t"

func text_passer(
		text: String,
		variables: Dictionary,
		mode: String = "renpy",
		links_color: String = ""
		) -> String:
	# passer for renpy or bbcode markup format
	# its retrun bbcode
	
	if links_color == "":
		if Engine.editor_hint:
			links_color = Color.aqua.to_html()
		
		else:
			links_color = Rakugo.tres.links_color
		

	url_open = url_open.replace("225ebf", links_color)

	if !text:
		return text

	var _text := text

	match mode:
		"renpy":
			text = parse_renpy_text(text, variables)

		"bbcode":
			text = parse_bbcode_text(text, variables)
	
	if !Engine.editor_hint:
		Rakugo.debug(["org: ''", _text, "', bbcode: ''", text , "'"])

	return text


func parse_text_adv(
		text: String, variables: Dictionary,
		open: String, close: String) -> String:

	if text == null:
		return ""

	text = text.c_unescape()

	for var_name in variables.keys():
		if text.find(var_name) == -1:
			continue # no variable in this string

		var variable:RakugoVar = variables[var_name]
		var type = Rakugo.Type.keys()[variable.type]

		Rakugo.debug([var_name, type, variable.value])
		text = variable.parse_text(text, open, close)

	return text


func parse_text_emojis(
		text: String, open: String,
		close: String) -> String:

	text = text.c_unescape()
	
	var emoj_size :=  16
	if !Engine.editor_hint:
		emoj_size = Rakugo.emoji_size
	
	for emoji_name in $Emojis.emojis_dict.keys():
		if text.find(emoji_name) == -1:
			continue # no variable in this string

		var emoji_png = $Emojis.get_path_to_emoji(emoji_name, emoj_size)
		var s = open + emoji_name + close
		var e = "[img]" + emoji_png + "[/img]"
		text = text.replace(s, e)

	return text


func if_empty_variables(text: String, open:String, close : String) -> String:
	var m := false
	var val := ""
	
	for letter in text:
		if letter == open:
			m = true
			continue
		
		if m:
			if letter == close:
				m = false
				
			else:
				val += letter
		
		else:
			text = text.replace(
				open + val + close, 
				"[code]" + val + "[/code]"
			)
	
	return text


func parse_renpy_text(text: String, variables: Dictionary) -> String:
	if variables.empty():
		text = if_empty_variables(text, "[", "]")
	
	else:
		text = parse_text_adv(text, variables, "[", "]")
	
	text = parse_text_emojis(text, "{:", ":}")
	text = text.replace("{a=", url_open)
	text = text.replace("{/a}", url_close)
	text = text.replace("{/nl}", new_line)
	text = text.replace("{/tab}", tab)
	text = text.replace("{", "[")
	text = text.replace("}", "]")
	return text


func parse_bbcode_text(text: String, variables: Dictionary) -> String:
	if variables.empty():
		text = if_empty_variables(text, "{", "}")
	
	else:
		text = parse_text_adv(text, variables, "{", "}")
	
	text = parse_text_emojis(text, "[:", ":]")
	text = text.replace("[url=", url_open)
	text = text.replace("[/url]", url_close)
	text = text.replace("[/url]", url_close)
	text = text.replace("[/tab]", tab)
	text = text.replace("[/nl]", new_line)
	return text
