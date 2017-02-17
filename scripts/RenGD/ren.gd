## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##


extends Control

onready var input_screen = get_node("Say/VBoxContainer/Input")
onready var say_screen = get_node("Say/VBoxContainer")
onready var label_manager = get_node("LabelManager")
onready var choice_screen = get_node("Choice")

var snum = 0 ## current statment number
var statments = []
var keywords = { "version":{"type":"text", "value":"0.6"} }


func _ready():
    ## code borrow from:
    ## http://docs.godotengine.org/en/stable/tutorials/step_by_step/singletons_autoload.html
    var root = get_tree().get_root()
    label_manager.current_scene = root.get_child( root.get_child_count() -1 )
    set_process_input(true)


func start_ren():
    ## This must be at end of code using ren api
	## this start ren "magic" ;)
    use_statment(0)


func next_statment():
    ## go to next statment
    use_statment(snum + 1)


func perv_statment():
    ## go to previous statment
    use_statment(snum - 1)


func _input(event):

    if input_screen._is_input_on == false:
        if event.is_action_pressed("ren_rollforward"):
            next_statment()
        
        elif event.is_action_pressed("ren_rollback"):
            prev_statment()
        

func use_statment(num):
    ## go to statment with given number
    if num <= statments.size() and num >= 0:
        var s = statments[num]
        
        if s.type == "say":
            _say(s.args)
        
        elif s.type == "input":
            _ren_input(s.args)
        
        elif s.type == "menu":
            _ren_menu(s.args)
        
        elif s.type == "g":
            callv(s.fun, s.args)
            
            if num + 1 <= statments.size():
                use_statment(num + 1)
        
        snum = num
    

## code borrow from:
## http://docs.godotengine.org/en/stable/tutorials/step_by_step/singletons_autoload.html
func goto_scene(path):

    ## This function will usually be called from a signal callback,
    ## or some other function from the running scene.
    ## Deleting the current scene at this point might be
    ## a bad idea, because it may be inside of a callback or function of it.
    ## The worst case will be a crash or unexpected behavior.

    ## The way around this is deferring the load to a later time, when
    ## it is ensured that no code from the current scene is running:

    call_deferred("_deferred_goto_scene", path)

## code borrow from:
## http://docs.godotengine.org/en/stable/tutorials/step_by_step/singletons_autoload.html
func _deferred_goto_scene(path):

    ## Immediately free the current scene,
    ## there is no risk here.
    label_manager.current_scene.free()

    ## Load new scene
    var s = load(path)

    ## Instance the new scene
    label_manager.current_scene = s.instance()

    ## Add it to the active scene, as child of root
    get_tree().get_root().add_child(label_manager.current_scene)

    ## optional, to make it compatible with the SceneTree.change_scene() API
    get_tree().set_current_scene( label_manager.current_scene )


func define(key_name, key_value = null):
    ## add global var that ren will see
    keywords[key_name] = {"type":"var", "value":key_value}


func say_passer(text):
    ## passer for renpy markup format
    ## its retrun bbcode

    ## code from Sebastian Holc solution:
    ## http://pastebin.com/K8zsWQtL

    for key_name in keywords:
        if text.find(key_name) == -1:
             continue # no keyword in this string
        
        var keyword = keywords[key_name]

        if keyword.type == "text":
            text = text.replace("[" + key_name + "]", str(keyword.value))
        
        elif keyword.type == "func":
            var func_result = call(keyword.value)
            text = text.replace("[" + key_name + "]", str(func_result))
        
        elif keyword.type == "var":
            var value = keyword.value
            text = text.replace("[" + key_name + "]", str(value))
    

    text = text.replace("{image", "[img")
    text = text.replace("{", "[")
    text = text.replace("}", "]")

    return text


func label(label_name, scene_path, node_path = null, func_name = null):
    ## this declare new label
    ## that make ren see label and can jump to it
    label_manager.label(label_name, scene_path, node_path, func_name)


func jump(label_name, args = []):
    ## go to other declared label
    label_manager.jump(label_name, args)


func say(how, what, renpy_format = true):
    ## add say statment

    var s = {"type":"say",
                "args":{
                        "how":how,
                        "what":what,
                        "format":renpy_format
                        }
            }
    
    statments.append(s)



func _say(args):
    say_screen.how = args.how
    say_screen.what = args.what
    say_screen.use_renpy_format(args.format)
    say_screen.say()


func input(ivar, what, temp = "", renpy_format = true):
    ## add input statment

    var s = {"type":"input",
                "args":{
                        "ivar":ivar,
                        "what":what,
                        "temp":temp,
                        "format":renpy_format
                        }
            }
    
    statments.append(s)


func _ren_input(args):
    input_screen.ivar = args.ivar
    input_screen.what = args.what
    input_screen.temp = args.temp
    input_screen.use_renpy_format(args.format)
    input_screen.input()

func menu(choices, title = ""):
    ## add menu statment
    var s = {
        "type":"menu",
        "args":
            {
            "title":title,
            "choices":choices
            }
    }

    statments.append(s)

func _ren_menu(args):
    choice_screen.choices = args.choices
    choice_screen.title = args.title
    choice_screen.menu()

func godot_line(fun, args = []):
    ## add g statment
    ## use it to execute godot func in rengd
    var s = {"type":"g",
            "fun":fun,
            "args":args
            }
    
    statments.append(s)



