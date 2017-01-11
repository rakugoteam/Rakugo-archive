## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.05 ##
## License MIT ##
## Copyright (c) 2016 Jeremi Biernacki ##

extends Control

onready var input_screen = get_node("Say/VBoxContainer/Input")
onready var say_screen = get_node("Say/VBoxContainer/Dialog")
onready var namebox_screen = get_node("Say/VBoxContainer/NameBox/Label")
onready var label_manager = get_node("LabelManager")

# var characters = []
var nodes        = []
var defs         = {}

func _ready():
    connect("input_event", self, "_on_click")

    ## code borrow from:
    ## http://docs.godotengine.org/en/stable/tutorials/step_by_step/singletons_autoload.html
    var root = get_tree().get_root()
    label_manager.current_scene = root.get_child( root.get_child_count() -1 )


func add_node(_label, _node, args):
    nodes.append({"label":_label, "node": _node.get_name(), "args": args})


func get_node_by_int(i):
    return nodes[i]


func get_last_node():
    var l = nodes.size() - 1
    return get_node_by_int(l)


func _on_click(event):
    if event.is_action_pressed("ui_accept"):
        if input_screen._is_input_on == false:
            get_last_node().node.show()


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

    call_deferred("_deferred_goto_scene",path)


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


func define(var_name, var_value = null):
    defs[var_name] = var_value

func say_passer(text):



    var pstr = ""
    var vstr = ""
   
    var b = false

    for t in text:

        if t == "[":
            b = true
            pstr += t

        elif t == "]":
            b = false
            pstr += t

        elif b:
            pstr += t
            vstr += t

        if typeof(vstr) != TYPE_STRING:
            vstr = var2str(vstr)

        text = text.replace(pstr, vstr)

    text = text.replace("{image", "[img")
    text = text.replace("{", "[")
    text = text.replace("}", "]")

    return text


func label(label_name, scene_path, node_path = null, func_name = null):
    label_manager.label_name = label_name
    label_manager.scene_path = scene_path
    label_manager.node_path = node_path
    label_manager.func_name = func_name


func jump(label_name, args = []):
    label_manager.jump(label_name, args)


func set_label_current_label(label_name):
    label_manager.set_label_current_label(label_name)


func say(how, what, renpy_format = true):
    say_screen.how = how
    say_screen.what = what
    say_screen.use_renpy_format(renpy_format)
    

