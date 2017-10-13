## This is Ren'GD API ##

## version: 0.1.0 ##
## License MIT ##
## Menu class statement ##

func _init(kwargs, index, statments):
	type = "menu"
	kws = ["choices", "title", "node", "func_name"]

func use():
    if title in kwargs:
        kwargs.title = text_passer(_kwargs.title)
    
    if choices in kwargs:
        if typeof(kwargs.choices) == TYPE_ARRAY:
            kwargs["raw_choices"] = []
            for ch in kwargs.choices:
                kwargs.raw_choices.append(ch)
                ch = text_passer(ch)
        
        elif typeof(kwargs.choices) == TYPE_DICTIONARY:
            kwargs["raw_choices"] = {}
            for ch in kwargs.choices:
                kwargs.raw_choices[ch.key] = ch.value
                ch.key = text_passer(ch.key)
    
    .use()

func next():
    if raw_choices in kwargs:
        if typeof(kwargs.raw_choices) == TYPE_DICTIONARY:
            if final_choice in kwargs:
                statements += kwargs.raw_choices[final_choice]
    
    .next()