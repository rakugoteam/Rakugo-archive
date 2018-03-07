## This is Ren API ##
## version: 0.5.0 ##
## License MIT ##

extends Object

func text_passer(text, values):
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

		for val_name in values.keys():
			if text.find(val_name) == -1:
				continue # no value in this string
			
			var value = values[val_name].value
			var type = values[val_name].type

			# print (val_name, " ",  type, " ",  value)
			var s = "[" + val_name + "]"
			if type == "text":
				text = text.replace(s, value)
			
#			elif type == "func":
#				var func_result = call(value)
#				text = text.replace("[" + val_name + "()]", str(func_result))
			
			elif type == "var":
				text = text.replace(s, str(value))
			
			elif type in ["dict", "character"]:
				var dict = value
				
				if type == "character":
					dict = value.kwargs

				text = text.replace(s, str(dict))
				
				for k in dict.keys():
					var sk = "[" + val_name + "." + k + "]"
					if text.find(s) == -1:
						continue # no value in this string
					
					var kvalue = dict[k]
					text = text.replace(sk, str(kvalue))
			
			elif type == "list":
				text = text.replace(s, str(value))
				
				for i in range(value.size()):
					var sa = "[" + val_name+"["+str(i)+"]]"
					if text.find(sa) == -1:
						continue # no value in this string
					
					text = text.replace(sa, str(value[i]))

			else:
				print(val_name," is unsuported value type: ", type)
			
		text = text.replace("{image", "[img")
		text = text.replace("{tab}", "/t".c_escape())
		text = text.replace("{", "[")
		text = text.replace("}", "]")
		# print("org: ''", _text, "', bbcode: ''", text , "'")

	return text