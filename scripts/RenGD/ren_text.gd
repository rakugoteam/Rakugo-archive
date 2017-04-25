## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##

extends Object

var keywords

func text_passer(text):
    ## passer for renpy markup format
    ## its retrun bbcode

    ## clean from tabs
    text = text.c_escape()
    text = text.replace("\t".c_escape(), "")
    text = text.c_unescape()

    ## code from Sebastian Holc solution:
    ## http://pastebin.com/K8zsWQtL

    for key_name in self.keywords:
        if text.find(key_name) == -1:
             continue # no keyword in this string
        
        var keyword = self.keywords[key_name]

        if keyword.type == "text":
            var value = keyword.value
            text = text.replace("[" + key_name + "]", str(value))
        
        elif keyword.type == "func":
            var func_result = call(keyword.value)
            text = text.replace("[" + key_name + "]", str(func_result))
        
        elif keyword.type == "var":
            var value = keyword.value
            text = text.replace("[" + key_name + "]", str(value))
        
        elif keyword.type == "dict" or "Character":
            var dict = keyword.value
            text = text.replace("[" + key_name + "]", str(dict))
            
            for k in dict:
                if text.find(key_name + "." + k) == -1:
                    continue # no keyword in this string
                
                var value = dict[k]
                text = text.replace("[" + key_name + "." + k + "]", str(value))
        
        elif keyword.type == "list":
            var list = keyword.value
            text = text.replace("[" + key_name + "]", str(list))
            
        #     for v in list:
        #         var i = list.find(v)
               
        #         if text.find(key_name +"["+i+"]") == -1:
        #             continue # no keyword in this string
                
        #         text = text.replace("[" + key_name+"["+i+"]]", str(v))

        else:
            print(key_name," is unsuported keyword type: ", keyword.type)
    

    text = text.replace("{image", "[img")
    text = text.replace("{tab}", "/t".c_unescape())
    text = text.replace("{", "[")
    text = text.replace("}", "]")

    return text