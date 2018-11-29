extends Object

func text_passer(text, variables, mode = "ren"):
	match mode:
		"ren":
			return renpy_passer(text, variables)
		"bbcode":
			return bbcode_passer(text, variables)

func vars_passer(text, variables, open_char, close_char):
	if text != "":

		## clean from tabs
		text = text.c_escape()
		text = text.replace("\t".c_escape(), "")
		text = text.c_unescape()

		## code from Sebastian Holc solution:
		## http://pastebin.com/K8zsWQtL

		for var_name in variables.keys():
			if text.find(var_name) == -1:
				continue # no variable in this string
			
			var value = variables[var_name].value
			var type = variables[var_name].type

			# Ren.debug([var_name, type, value])
			var s = open_char + var_name + close_char
			if type == Ren.Type.TEXT:
				text = text.replace(s, value)
			
			# elif type == "func":
			# 	var func_result = call(variable)
			# 	text = text.replace(open_char + var_name + "()]", str(func_result))
			
			elif type == Ren.Type.VAR:
				text = text.replace(s, str(value))
			
			elif type in [Ren.Type.DICT, Ren.Type.CHARACTER]:
				var dict = value

				text = text.replace(s, str(dict))
				
				for k in dict.keys():
					var sk = open_char + var_name + "." + k + close_char
					if text.find(sk) == -1:
						continue # no variable in this string
					
					var kvalue = str(dict[k])
					# need testing
					if k == "name" and type == Ren.Type.CHARACTER:
						kvalue = dict.parse_character()
					
					text = text.replace(sk, kvalue)
			
			elif type == Ren.Type.LIST:
				text = text.replace(s, str(value))
				
				for i in range(value.size()):
					var sa = open_char + var_name + "[" + str(i) + "]" + close_char
					if text.find(sa) == -1:
						continue # no variable in this string
					
					text = text.replace(sa, str(value[i]))

			else:
				print(var_name," is unsuported variable type: ", type)
		
		return text

func renpy_passer(text, variables):
	## passer for renpy markup format
	## its return bbcode

	text = vars_passer(text, variables, "[", "]")
	text = text.replace("{image", "[img")
	text = text.replace("{a=", "[url=")
	text = text.replace("{/a}", "[/url]")
	text = text.replace("{nl}", "\n")
	text = text.replace("{tab}", "\t")
	text = text.replace("{", "[")
	text = text.replace("}", "]")

	# Ren.debug("org: ''", _text, "', bbcode: ''", text , "'")

	return text


func bbcode_passer(text, variables):
	## passer for renpy markup format
	## its return bbcode

	text = vars_passer(text, variables, "{", "}")
	text = text.replace("[nl]", "\n")
	text = text.replace("[tab]", "\t")

	# Ren.debug("org: ''", _text, "', bbcode: ''", text , "'")

	return text