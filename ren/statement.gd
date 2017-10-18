## This is Ren'GD API ##

## version: 0.1.0 ##
## License MIT ##

extends Node

###						###
###	Text Passer	import	###
###						###

const _TXT = preload("ren_text.gd")
onready var _txt = _TXT.new()

func text_passer(text = "", values = {}):
	## passer for renpy markup format
	## its retrun bbcode
	return _txt.text_passer(values, text)

## version: 0.1.0 ##
## License MIT ##
## Base class for statement ##

var type = "base"
var id = 0 # postion of statment in statements list
var kwargs = {} # dict of pairs keyword : argument
				# they are passed from one statment to another
var kws = [] # possible keywords for this type of statement
var statments # statements list includning this statment
var _ren # to attach node with main ren script (ren.gd)
		# needed to send singals 

func _init(kwargs, index, statments):
    self.id = index
    self.kwargs = kwargs
    self.statments = statments

func use():
    debug(kws)
    ren.emit_signal("statement", type, kwargs)
    
func next(types = []):
    var next_sid = find_next(types)
    if next_sid > -1:
        statements[next_sid].use()

func find_next(types = []):
    var next_sid = -1
    
    if id + 1 <= statements.size():
        if stype == []:
            next_sid = id + 1
        
        else:
            for i in range(id, statements.size()):
                if statements[i].type in types:
                    next_sid = statements[i].id
                    break
    
    return next_sid


func debug(kws = []):
    dbg = type + "("
    
    for k in _kwargs:
        if k in kws:
            dbg += k + " = " + _kwargs[k] +", "
    
    dbg += ")"
    print(dbg)