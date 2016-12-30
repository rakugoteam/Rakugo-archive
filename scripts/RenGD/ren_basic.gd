extends Node

# This is Ren'GD API
# version: 0.0.1

var _characters = []
var _screens = []
var _images = []
var _vars = {}

# var quotes - it don't work :(
# var apostrophe

func define(var_name, var_value):
  _vars.var_name = var_value

func get_var():
  return _vars.var_name

func line_passer(text):
  var fun
  var args

  if text.begins_with("$"):
    var spl = text.find("(")
    var end = text.find_last(")")

    fun = text.substr(1, spl - 1)
    fun = fun.replace(" ", "")
    fun = fun.replace("$", "")

    args = text.substr(spl + 1, end - spl - 1)
    args = args.c_escape()
    args = args.split(",")

    for a in args:

      if(a.begins_with('\"'.c_escape())
        or a.begins_with('\''.c_escape())):
        a = a.c_unescape()

      else:
         a = str2var(a)

    #callv(fun, args)

    return [fun, args]


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
