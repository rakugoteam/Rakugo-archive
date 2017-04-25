## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##

extends Object

var keywords

func define(key_name, key_value = null):
    ## add global var that ren will see
    if typeof(key_value) == TYPE_STRING:
        keywords[key_name] = {"type":"text", "value":key_value}

    elif typeof(key_value) == TYPE_DICTIONARY:
        
        if key_value.keys() == Character().keys():
            keywords[key_name] = {"type":"Character", "value":key_value}
        
        else:
             keywords[key_name] = {"type":"dict", "value":key_value}
    
    elif typeof(key_value) == TYPE_ARRAY:
        keywords[key_name] = {"type":"list", "value":key_value}
    
    else:
        keywords[key_name] = {"type":"var", "value":key_value}


func Character(name="", color ="", what_prefix="", what_suffix="", kind="adv"):
    ## return new Character
    return {"name":name, "color":color, "what_prefix":what_prefix,
            "what_suffix":what_suffix, "kind":kind}