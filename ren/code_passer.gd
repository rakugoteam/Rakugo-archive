## This is Ren API ##

## version: 0.2.0 ##
## License MIT ##

## Main Ren class ## 

extends Node

func base_replace(text, val_name):
	var rtext = text.replace(" " + val_name + " ", "ren.values." + val_name)
	rtext = rtext.c_escape()
	rtext = rtext.replace(" " + val_name + "\n".c_escape(), "ren.values." + val_name + "\n".c_escape())
	return rtext.c_unescape()

func code_passer(text, values):

	if text != "":

		for val_name in values.keys():
			if text.find(val_name) == -1:
				continue # no value in this string
		
			if type == ("text" or "var"):
				text = base_replace(text, val_name)
			
			elif type == "func":
				text = text.replace(" " + val_name + "()", "ren.values." + val_name + "()")
			
			elif type in ["dict", "character"]:
				var dict = value
				
				if type == "character":
					dict = value.kwargs

				text = text.replace("[" + val_name + "]", str(dict))
				
				for k in dict.keys():
					if text.find(val_name + "." + k) == -1:
						continue # no value in this string
					
					var value = dict[k]
					text = text.replace("[" + val_name + "." + k + "]", str(value))