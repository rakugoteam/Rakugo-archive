## This is Ren API ##

## version: 0.1.0 ##
## License MIT ##

extends Object

func text_passer(text, values):
	## passer for renpy markup format
	## its retrun bbcode

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
			
			if type == "text":
				text = text.replace("[" + val_name + "]", value)
			
			elif type == "func":
				var func_result = call(value)
				text = text.replace("[" + val_name + "]", str(func_result))
			
			elif type == "var":
				text = text.replace("[" + val_name + "]", str(value))
			
			elif type == "dict" or "Character":
				var dict = value
				text = text.replace("[" + val_name + "]", str(dict))
				
				for k in dict:
					if text.find(val_name + "." + k) == -1:
						continue # no value in this string
					
					var value = dict[k]
					text = text.replace("[" + val_name + "." + k + "]", str(value))
			
			elif type == "list":
				text = text.replace("[" + val_name + "]", str(value))
				
			#	for v in list:
			#		var i = list.find(v)
				
			#		if text.find(val_name +"["+i+"]") == -1:
			#			continue # no value in this string
					
			#			text = text.replace("[" + val_name+"["+i+"]]", str(v))

			else:
				print(val_name," is unsuported value type: ", type)
		
			
		text = text.replace("{image", "[img")
		text = text.replace("{tab}", "/t".c_escape())
		text = text.replace("{", "[")
		text = text.replace("}", "]")

	return text