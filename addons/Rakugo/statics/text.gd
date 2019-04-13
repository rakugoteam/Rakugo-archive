extends Node
class_name RakugoTextPasser

var url_open:String = "[color=225ebf][url="
var url_close:String = "[/url][/color]"
var new_line:String = "\n"
var tab:String = "\t"

onready var emojis : Emojis = $Emojis 

func text_passer(
	text:String,
	variables:Dictionary, 
	mode:String = "renpy",
	links_color:String = "225ebf"
	) -> String:
	## passer for renpy or bbcode markup format
	## its retrun bbcode

	url_open = url_open.replace("225ebf", links_color)

	if !text:
		return text
	
	match mode:
		"renpy":
			text = parse_renpy_text(text, variables)

		"bbcode":
			text = parse_bbcode_text(text, variables)
	
	
	# Rakugo.debug("org: ''", _text, "', bbcode: ''", text , "'")

	return text

func dict_or_character(
	var_name:String, open:String,
	s:String, close:String, dict,
	text:String, type:int,
	variables:Dictionary) -> String:
	text = text.replace(s, str(dict))
	
	for k in dict.keys():
		var sk = open + var_name + "." + k + close
		if text.find(sk) == -1:
			continue # no variable in this string
		
		var kvalue = str(dict[k])

		if k == "name" and type == Rakugo.Type.CHARACTER:
			kvalue = variables[var_name].parse_character()
		
		text = text.replace(sk, kvalue)
	
	return text

func parse_text_adv(
	text:String, variables:Dictionary,
	open:String, close:String) -> String:
	## code from Sebastian Holc solution:
	## http://pastebin.com/K8zsWQtL

	text = text.c_unescape()

	for var_name in variables.keys():
		if text.find(var_name) == -1:
			continue # no variable in this string
		
		var value = variables[var_name].value
		var type = variables[var_name].type

		# Rakugo.debug([var_name, type, value])
		var s = open + var_name + close

		match type:
			Rakugo.Type.TEXT:
				text = text.replace(s, value)
		
			Rakugo.Type.VAR:
				text = text.replace(s, str(value))
		
			Rakugo.Type.DICT:
				text = dict_or_character(
					var_name, open, s, close,
					value, text, type, variables
				)
			
			Rakugo.Type.CHARACTER:
				text = dict_or_character(
					var_name, open, s, close,
					value, text, type, variables
				)
		
			Rakugo.Type.LIST:
				text = text.replace(s, str(value))
				
				for i in range(value.size()):
					var sa = open + var_name + open + str(i) + close + close
					if text.find(sa) == -1:
						continue # no variable in this string
					
					text = text.replace(sa, str(value[i]))

			_:
				print(var_name," is unsuported variable type: ", type)
		
	return text

func parse_text_emojis(
	text:String, open:String,
	close:String) -> String:

	text = text.c_unescape()

	for emoji_name in emojis.emojis_dict.keys():
		if text.find(emoji_name) == -1:
			continue # no variable in this string
		
		var emoji_png = emojis.get_path_to_emoji(emoji_name, Rakugo.emoji_size)
		var s = open + emoji_name + close
		var e = "[img]" + emoji_png + "[/img]"
		text = text.replace(s, e)
	
	return text
			

func parse_renpy_text(text:String, variables:Dictionary) -> String:
	text = parse_text_adv(text, variables, "[", "]")
	text = parse_text_emojis(text, "{:", ":}")
	text = text.replace("{a=", url_open)
	text = text.replace("{/a}", url_close)
	text = text.replace("{/nl}", new_line)
	text = text.replace("{/tab}", tab)
	text = text.replace("{", "[")
	text = text.replace("}", "]")
	return text

func parse_bbcode_text(text:String, variables:Dictionary) -> String:
	text = parse_text_adv(text, variables, "{", "}")
	text = parse_text_emojis(text, "[:", ":]")
	text = text.replace("[url=", url_open)
	text = text.replace("[/url]", url_close)
	text = text.replace("[/url]", url_close)
	text = text.replace("[/tab]", tab)
	text = text.replace("[/nl]", new_line)
	return text