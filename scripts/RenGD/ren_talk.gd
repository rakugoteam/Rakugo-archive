## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.7 ##
## License MIT ##

extends Node

var talk_name
var current_scene
var current_scene_path
var node_path
var func_name

var talks = {}

signal enter_talk

func _Etalk(talk):
    print(talk, " is not definited")


func _talk(talk, sc_path, n_path = "", f_name = ""):
    talk_name = talk
    current_scene_path = sc_path
    node_path = n_path
    func_name = f_name


func talk(talk, sc_path, n_path = "", f_name = ""):
    _talk(talk, sc_path, n_path, f_name)
    talks[talk] = {"scene_path":sc_path, "node_path":n_path, "func_name":f_name}


func set_current_talk(talk):
    if talk in talks.keys():
        var l = talks[talk]
        _talk(talk, l.scene_path, l.node_path, l.func_name)
        print("set_current_talk as ", talk, ", ", l.scene_path, ", ", l.node_path, ", ", l.func_name)
    else:
        _Etalk(talk)


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
    current_scene.free()

    ## Load new scene
    var s = load(path)

    ## Instance the new scene
    current_scene = s.instance()

    ## Add it to the active scene, as child of root
    get_tree().get_root().add_child(current_scene)

    ## optional, to make it compatible with the SceneTree.change_scene() API
    get_tree().set_current_scene(current_scene)


func jump(talk, args = []):

    if talk in talks.keys():
    
        var vtalk = talks[talk]
        talk_name = talk

        if current_scene_path != vtalk.scene_path:
            goto_scene(vtalk.scene_path)
            current_scene_path = vtalk.scene_path

        print("old node path: ", node_path)

        if vtalk.node_path == "": ## asume that developer want to use root of scene
            node_path = get_node_path(current_scene)

        elif node_path == vtalk.node_path:
            pass

        else:
            node_path = vtalk.node_path

        print("new node path: ", node_path)

        func_name = vtalk.func_name
        
        if func_name != "": ## else asume that developer want to use _ready as talk
            connect("enter_talk", get_node(node_path), func_name, args)
            emit_signal("enter_talk")
    
    else:
        print(talk, " is not definited")
