extends Object

func text_passer(text, variables):
	## passer for renpy markup format
	## its retrun bbcode
	# var _text = text
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

			# print (var_name, " ",  type, " ",  value)
			var s = "[" + var_name + "]"
			if type == "text":
				text = text.replace(s, value)
			
#			elif type == "func":
#				var func_result = call(variable)
#				text = text.replace("[" + var_name + "()]", str(func_result))
			
			elif type == "var":
				text = text.replace(s, str(value))
			
			elif type in ["dict", "character"]:
				var dict = value
				
				if type == "character":
					dict = value.kwargs

				text = text.replace(s, str(dict))
				
				for k in dict.keys():
					var sk = "[" + var_name + "." + k + "]"
					if text.find(sk) == -1:
						continue # no variable in this string
					
					var kvalue = dict[k]
					text = text.replace(sk, str(kvalue))
			
			elif type == "list":
				text = text.replace(s, str(value))
				
				for i in range(value.size()):
					var sa = "[" + var_name+"["+str(i)+"]]"
					if text.find(sa) == -1:
						continue # no variable in this string
					
					text = text.replace(sa, str(value[i]))

			else:
				print(var_name," is unsuported variable type: ", type)
			
		text = text.replace("{image", "[img")
		text = text.replace("{nl}", "\n")
		text = text.replace("{tab}", "\t")
		text = text.replace("{", "[")
		text = text.replace("}", "]")
		# print("org: ''", _text, "', bbcode: ''", text , "'")

	return text