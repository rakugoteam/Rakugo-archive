## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##

extends Node

var keywords = { "version":{"type":"text", "value":"0.6"} }

func define(key_name, key_value = null):
    ## add global var that ren will see
    keywords[key_name] = {"type":"var", "value":key_value}


func define_ch(key_name, character_value = {}):
    ## add global Character var that ren will see
    keywords[key_name] = {"type":"Character", "value":character_value}


func define_dict(key_name, dict = {}):
    ## add global dict var that ren will see
    keywords[key_name] = {"type":"dict", "value":dict}

# func define_list(key_name, list = []):
#     ## add global dict var that ren will see
#     keywords[key_name] = {"type":"list", "value":list}


func Character(name="", color ="", what_prefix="", what_suffix="", kind="adv"):
    ## return new Character
    return {"name":name, "color":color, "what_prefix":what_prefix,
            "what_suffix":what_suffix, "kind":kind}