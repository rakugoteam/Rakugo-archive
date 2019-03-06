extends Object
class_name RakugoTextPasser

var url_open:String = "[color=225ebf][url="
var url_close:String = "[/url][/color]"

func text_passer(
	text:String,
	variables:Dictionary, 
	mode:String = "renpy",
	links_color:String = "225ebf"
	) -> String:
	## passer for renpy or bbcode markup format
	## its retrun bbcode

	url_open = url_open.replace("225ebf", links_color)

	if text == "":
		return text
	
	match mode:
		"renpy":
			text = parse_rakugo_text(text, variables)

		"bbcode":
			text = parse_bbcode_text(text, variables)
	
	
	# Rakugo.debug("org: ''", _text, "', bbcode: ''", text , "'")

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
		if type == Rakugo.Type.TEXT:
			text = text.replace(s, value)
		
		elif type == Rakugo.Type.VAR:
			text = text.replace(s, str(value))
		
		elif type in [Rakugo.Type.DICT, Rakugo.Type.CHARACTER]:
			var dict = value

			text = text.replace(s, str(dict))
			
			for k in dict.keys():
				var sk = open + var_name + "." + k + close
				if text.find(sk) == -1:
					continue # no variable in this string
				
				var kvalue = str(dict[k])

				if k == "name" and type == Rakugo.Type.CHARACTER:
					kvalue = variables[var_name].parse_character()
				
				# if "()" in k:
				# 	kvalue = variables[var_name].callv()
				
				text = text.replace(sk, kvalue)
		
		elif type == Rakugo.Type.LIST:
			text = text.replace(s, str(value))
			
			for i in range(value.size()):
				var sa = open + var_name + open + str(i) + close + close
				if text.find(sa) == -1:
					continue # no variable in this string
				
				text = text.replace(sa, str(value[i]))

		else:
			print(var_name," is unsuported variable type: ", type)
		
	return text

func parse_rakugo_text(text:String, variables:Dictionary) -> String:
	text = parse_text_adv(text, variables, "[", "]")
	text = text.replace("{image", "[img")
	text = text.replace("{a=", url_open)
	text = text.replace("{/a}", url_close)
	text = text.replace("{", "[")
	text = text.replace("}", "]")
	return text

func parse_bbcode_text(text:String, variables:Dictionary) -> String:
	text = parse_text_adv(text, variables, "{", "}")
	text = text.replace("[url=", url_open)
	text = text.replace("[/url]", url_close)
	return text
	
func parse_markdown_text(text:String, variables:Dictionary) -> String:

    
    return text
