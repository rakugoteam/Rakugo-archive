extends Node

# This is Ren'GD API
# version: 0.0.1

var _characters = []
var _screens = []
var _images = []
var _vars = {}


func define(name_var, var_value):
  _vars.name_var = var_value


func line_passer(text):
  var fun
  var args

  if text.begins_with("$"):
    var spl = text.find("(")
    var end = text.find_last(")")

    fun = text.substr(1, spl - 1)
    fun = fun.replace(" ", "")
    fun = fun.replace("$", "")

    args = text.substr(spl + 1, end - 1)
    args = args.split(",")

    for a in args:
      a = str2var(a)

    callv(fun, args)


func str_passer(text):
	var pstr = ""
	var vstr = ""
	var b = false

	var i = 1

	for t in text:

		if t == "[":
			b = true
			pstr += t

		elif t == "]":
			b = false
			pstr += t
			vstr = var2str(_get_var(vstr))
			text = text.replace(pstr, vstr)

		elif b:
			pstr += t
			vstr += t

	text = text.replace("{image", "[img")
	text = text.replace("{", "[")
	text = text.replace("}", "]")

	return text
