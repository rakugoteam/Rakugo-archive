extends Object
class_name RenTextPasser

var url_open:String = "[color=225ebf][url="
var url_close:String = "[/url][/color]"
var new_line:String = "\n"
var tab:String = "\t"

func text_passer(
	text:String, variables:Dictionary, 
	mode:String = "ren",
	links_color:String = "225ebf") -> String:
	## passer for renpy or bbcode markup format
	## its retrun bbcode

	url_open = url_open.replace("225ebf", links_color)

	if text == "":
		return text
	
	match mode:
		"ren":
			text = parse_ren_text(text, variables)

		"bbcode":
			text = parse_bbcode_text(text, variables)
	
	
	# Ren.debug("org: ''", _text, "', bbcode: ''", text , "'")

	return text

func parse_text_adv(
	text:String, variables:Dictionary,
	open:String, close:String) -> String:
	## code from Sebastian Holc solution:
	## http://pastebin.com/K8zsWQtL

	for var_name in variables.keys():
		if text.find(var_name) == -1:
			continue # no variable in this string
		
		var value = variables[var_name].value
		var type = variables[var_name].type

		# Ren.debug([var_name, type, value])
		var s = open + var_name + close
		if type == Ren.Type.TEXT:
			text = text.replace(s, value)
		
		elif type == Ren.Type.VAR:
			text = text.replace(s, str(value))
		
		elif type in [Ren.Type.DICT, Ren.Type.CHARACTER]:
			var dict = value

			text = text.replace(s, str(dict))
			
			for k in dict.keys():
				var sk = open + var_name + "." + k + close
				if text.find(sk) == -1:
					continue # no variable in this string
				
				var kvalue = str(dict[k])

				if k == "name" and type == Ren.Type.CHARACTER:
					kvalue = variables[var_name].parse_character()
				
				# if "()" in k:
				# 	kvalue = variables[var_name].callv()
				
				text = text.replace(sk, kvalue)
		
		elif type == Ren.Type.LIST:
			text = text.replace(s, str(value))
			
			for i in range(value.size()):
				var sa = open + var_name + open + str(i) + close + close
				if text.find(sa) == -1:
					continue # no variable in this string
				
				text = text.replace(sa, str(value[i]))

		else:
			print(var_name," is unsuported variable type: ", type)
		
	return text

func parse_ren_text(text:String, variables:Dictionary) -> String:
	text = parse_text_adv(text, variables, "[", "]")
	text = text.replace("{image", "[img")
	text = text.replace("{a=", url_open)
	text = text.replace("{/a}", url_close)
	text = text.replace("{/nl}", new_line)
	text = text.replace("{/tab}", tab)
	text = text.replace("{", "[")
	text = text.replace("}", "]")
	return text

func parse_bbcode_text(text:String, variables:Dictionary) -> String:
	text = parse_text_adv(text, variables, "{", "}")
	text = text.replace("[url=", url_open)
	text = text.replace("[/url]", url_close)
	text = text.replace("[/nl]", new_line)
	text = text.replace("[/tab]", tab)
	return text
