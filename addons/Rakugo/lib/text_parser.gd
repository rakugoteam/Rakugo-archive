extends Node

var emojis = Emojis.new()


func parse(text:String, _markup=null):
	if not _markup:
		_markup = Settings.get("rakugo/game/text/markup")
	
	text = dirty_escaping(text)
	match _markup:
		"renpy":
			text = convert_renpy_markup(text)
	text = replace_variables(text)
	return text

func convert_renpy_markup(text:String):
	var re = RegEx.new()
	var output = "" + text
	var offset = 0
	var replacement = ""
	
	re.compile("(?<!\\[)\\[([\\w.]+)\\]")#Convert compatible variable inclusion
	for result in re.search_all(output):
		if result.get_string():
			output = output.left(result.get_start()) + "<" + result.get_string(1) + ">" + output.right(result.get_end())
	
	re.compile("(?<!\\[)\\[([^\\]]+)\\]")#Check there is still some variable inclusion and complain if so
	for result in re.search_all(output):
		if result.get_string():
			push_error("Incompatible variable inclusion '%s'" % result.get_string())
	
	re.compile("(?<!\\{)\\{(\\/{0,1})a(?:(=)|\\})")#match unescaped "{a=" and "{/a}"
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[" + result.get_string(1) + "url"
			if result.get_string(2):
				replacement += "="
			else:
				replacement += "]"
			output = output.left(result.get_start() + offset) + replacement + output.right(result.get_end() + offset)
			offset += replacement.length() - result.get_string().length()

	re.compile("(?<!\\{)\\{img=([^\\}]+)\\}")#match unescaped "{img=<path>}"
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[img]" + result.get_string(1) + "[/img]"
			output = output.left(result.get_start() + offset) + replacement + output.right(result.get_end() + offset)
			offset += replacement.length() - result.get_string().length()
	
	re.compile("(?:(?<!\\{)\\{[^\\{\\}]+)(\\})")#math "}" part of a valid tag
	for result in re.search_all(output):
		if result.get_string():
			output = output.left(result.get_start(1)) + "]" + output.right(result.get_end(1))
	
	re.compile("(?<!\\{)\\{(?!\\{)")#match unescaped "{"
	for result in re.search_all(output):
		if result.get_string():
			output = output.left(result.get_start()) + "[" + output.right(result.get_end())
	
	re.compile("([\\{]+)")#match escaped braces "{{" transform them into "{"
	for result in re.search_all(output):
		if result.get_string():
			output = output.left(result.get_start()) + "{" + output.right(result.get_end())
	

	return output


func dirty_escaping(text:String):
	var re = RegEx.new()
	var output = "" + text
	var offset = 0
	
	re.compile("(\\\\)(.)")
	for result in re.search_all(text):
		if result.get_string():
			print("'", result.get_string(0),"'  '",result.get_string(1),"'  '", result.get_string(2),"'")
			output = output.left(result.get_start() + offset) + "\u200B" + result.get_string(2) + "\u200B" + output.right(result.get_end() + offset)
			offset += 1
	
	return output


func dirty_escaping_sub(text:String, substring:String):
	text.replace(substring, "\u200B" + substring + "\u200B")
	return text


func replace_variables(text:String):
	var re = RegEx.new()
	var output = "" + text
	var offset = 0
	var replacement = ""
	
	re.compile("<([\\w.]+)>")
	for result in re.search_all(text):
		if result.get_string():
			replacement = str(get_variable(result.get_string(1)))
			output = output.left(result.get_start() + offset) + replacement + output.right(result.get_end() + offset)
			offset += replacement.length() - result.get_string().length()
	
	return output

func replace_emojis(text:String):
	var re = RegEx.new()
	var output = "" + text
	var offset = 0
	var replacement = ""
	
	re.compile("\\[\\:([\\w.]+)\\:\\]")
	for result in re.search_all(text):
		if result.get_string():
			replacement = "[img]" + emojis.get_path_to_emoji(result.get_string(1)) + "[/img]"
			output = output.left(result.get_start() + offset) + replacement + output.right(result.get_end() + offset)
			offset += replacement.length() - result.get_string().length()
	
	return output

func get_variable(var_name:String):
	var parts = var_name.split('.', false)
	
	var output = Rakugo.store
	var i = 0
	var error = false
	while output and i < parts.size():
		output = output.get(parts[i])
		i += 1
		if not output:
			error = true
			push_warning("The variable '%s' does not exist." % var_name)
	if error:
		output = null
	return output
