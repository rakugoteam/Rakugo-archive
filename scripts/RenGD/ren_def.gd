## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.7 ##
## License MIT ##

extends Object

func define(keywords, key_name, key_value = null):
    ## add global var that ren will see
    var key_type = "var"

    if key_value != null:
        var type = typeof(key_value)

        if type == TYPE_STRING:
            key_type = "text"
        
        elif type == TYPE_DICTIONARY:
            if key_value.keys() == Character().keys():
                key_type = "Character"
            
            else:
                key_type = "dict"
        
        elif type == TYPE_ARRAY:
            key_type = "list"
            print('list are not fully sported by text_passer')
        
    
    keywords[key_name] = {"type":key_type, "value":key_value}



func Character(name="", color ="", what_prefix="", what_suffix="", kind="adv"):
    ## return new Character
    return {"name":name, "color":color, "what_prefix":what_prefix,
            "what_suffix":what_suffix, "kind":kind}