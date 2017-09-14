## This is Ren'GD API ##

## version: 0.1.0 ##
## License MIT ##
## Say class statement ##

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
###	Say statement class		###
###							###

type = "menu"
_kwargs = {"choices":"", "title":"", "node":, "func_name":""}

func use():
    if title in _kwargs:
        _kwargs.title = text_passer(_kwargs.title)
    
    if choices in _kwargs:
        if typeof(_kwargs.choices) == TYPE_ARRAY:
            _kwargs["raw_choices"] = []
            for ch in _kwargs.choices:
                _kwargs.raw_choices.append(ch)
                ch = text_passer(ch)
        
        elif typeof(_kwargs.choices) == TYPE_DICTIONARY:
            _kwargs["raw_choices"] = {}
            for ch in _kwargs.choices:
                _kwargs.raw_choices[ch.key] = ch.value
                ch.key = text_passer(ch.key)
    
    .use()



func next():
    if raw_choices in _kwargs:
        if typeof(_kwargs.raw_choices) == TYPE_DICTIONARY:
            if final_choice in _kwargs:
                ren.statements += _kwargs.raw_choices[final_choice]
    
    .next()