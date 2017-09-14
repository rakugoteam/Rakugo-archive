## This is Ren'GD API ##

## version: 0.1.0 ##
## License MIT ##
## ren_input statement class ##

extends "res://RenGD/statement.gd"

###						###
###	Text Passer	import	###
###						###

const REN_TXT = preload("ren_text.gd")
onready var ren_txt = REN_TXT.new()

func text_passer(text = ""):
	## passer for renpy markup format
	## its retrun bbcode
	return ren_txt.text_passer(ren.vars, text)

###							###
###	Input statement class	###
###							###

type = "input"
_kwargs = {"ivar":"", "what":"", "temp":"", "vars":[]}

func use():
    if what in _kwargs:
        _kwargs.what = text_passer(_kwargs.what)
    
    if temp in _kwargs:
        _kwargs.temp = text_passer(_kwargs.temp)

    .use(false)


func next():
    var type = "text"
    var value = _kwargs.value
    var input_var = _kwargs.input_var

	if value.is_valid_integer():
		value = int(value)
	
	elif value.is_valid_float():
		value = float(value)

	if typeof(value) != TYPE_STRING:
		type = "var"
    
    if vars in _kwargs:
	    _kwargs.vars[input_var] = {"type":type, "value":value}
    
    .next()


func debug():
    .debug(["ivar", "what", "temp", "vars"])