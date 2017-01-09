
## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.04 ##
## License MIT ##
## Copyright (c) 2016 Jeremi Biernacki ##

extends Node

onready var _choice_screen = get_node("Choice")
onready var _input_screen = get_node("Say/VBoxContainer/Input")
onready var _say_screen = get_node("Say/VBoxContainer/Dialog")
onready var _namebox_screen = get_node("Say/VBoxContainer/NameBox/Label")
onready var _input = get_node("Say/VBoxContainer/Input")

# var characters = []
var objects = []
var labels = {}
var defs = {}

var _is_input_on = false
var _input_var
var current_label 
var current_scene
var current_scene_path

func _ready():
    _input_screen.connect("text_entered", self, "_on_input")

    ## code borrow from:
    ## http://docs.godotengine.org/en/stable/tutorials/step_by_step/singletons_autoload.html
    var root = get_tree().get_root()
    current_scene = root.get_child( root.get_child_count() -1 )

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
    current_scene.free()

    ## Load new scene
    var s = load(path)

    ## Instance the new scene
    current_scene = s.instance()

    ## Add it to the active scene, as child of root
    get_tree().get_root().add_child(current_scene)

    ## optional, to make it compatible with the SceneTree.change_scene() API
    get_tree().set_current_scene( current_scene )


func define(var_name, var_value = null):
    defs[var_name] = var_value


class label extends Object:
    func _init(label_name, scene_path, node_path = null,  func_name = null):
        var name = label_name
        var scene = scene_path
        var node = node_path
        var fun = func_name

        labels[name] = self

    func jump(args = []):

        if scene != current_scene_path:
            goto_scene(scene)
            current_scene_path = scene

        if node == null: ## asume that developer want to use parent of scene
            node = current_scene
        
        else:
            node = get_node(current_scene.get_path() + "/" + node)

        if fun == null: ## asume that developer want to use _ready as label
            pass
        
        else:
            node.callv(fun, args)
        
        current_label = self
        

func add_object(_label, _object):
    objects.append({"label":_label, "object": _object})


class input extends Object:
    func _init(_ivar, _what, _temp = "", use_renpy_fromat = true):
        var temp = _temp
        var what = _what
       
        var ivar = _ivar

        if use_renpy_format:
            temp = str_passer(temp)
            what = str_passer(what)
        
        add_object(current_label, self)

    func show():
        _input.set_text(temp)
        _namebox_screen.set_bbcodes(what)

        _say_screen.hide()
        _input.show()
        _input_var = ivar
        _is_input_on = true


func _on_input(s):
    set(_input_var, s)


class say extends Object:
    func _init(_how, _what, use_renpy_fromat = true):
        var how = _how
        var what = _what

        if use_renpy_fromat:
            how = say_passer(how)
            what = say_passer(what)
       
        add_object(current_label, self)

    func show():
        _namebox_screen.set_bbcode(how)
        _say_screen.set_bbcode(what)
        
        _say_screen.show()
        _input.hide()

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

            if not vstr.typeof(TYPE_STRING):
                vstr = var2str(vstr)

    		text = text.replace(pstr, vstr)

    	elif b:
    		pstr += t
    		vstr += t

    text = text.replace("{image", "[img")
    text = text.replace("{", "[")
    text = text.replace("}", "]")

    return text
