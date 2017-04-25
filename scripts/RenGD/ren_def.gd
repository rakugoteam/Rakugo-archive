## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##

extends Object

var keywords

func define(key_name, key_value = null):
    ## add global var that ren will see
    if key_value.type == typeof(TYPE_STRING):
        keywords[key_name] = {"type":"text", "value":key_value}

    elif key_value.type == typeof(TYPE_DICTIONARY):
        
        if key_value.keys() == Character().keys():
            keywords[key_name] = {"type":"Character", "value":key_value}
        
        else:
             keywords[key_name] = {"type":"dict", "value":key_value}
    
    elif key_value.type == typeof(TYPE_ARRAY):
        keywords[key_name] = {"type":"list", "value":list}
    
    else:
        keywords[key_name] = {"type":"var", "value":key_value}


func Character(name="", color ="", what_prefix="", what_suffix="", kind="adv"):
    ## return new Character
    return {"name":name, "color":color, "what_prefix":what_prefix,
            "what_suffix":what_suffix, "kind":kind}