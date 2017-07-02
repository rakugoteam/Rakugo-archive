## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.7 ##
## License MIT ##

extends Node

var talk_name
var scene_path
var current_scene
var current_scene_path
var node_path
var func_name

var talks = {}

func _Etalk(talk):
    print(talk, " is not definited")


func _talk(talk, sc_path, n_path = null, f_name = null):
    talk_name = talk
    scene_path = sc_path
    node_path = n_path
    func_name = f_name


func talk(talk, sc_path, n_path = null, f_name = null):
    _talk(talk, sc_path, n_path, f_name)
    talks[talk] = [sc_path, n_path, f_name]


func set_current_talk(talk):
    if talk in talks.keys():
        var l = talks[talk]
        _talk(talk, l[0], l[1], l[2])
    
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
        talk_name = talk
        if scene_path != current_scene_path:
            goto_scene(scene_path)
            current_scene_path = scene_path

        if node_path == null: ## asume that developer want to use root of scene
            node_path = current_scene
        
        else:
            node_path = get_node(current_scene.get_path() + "/" + node_path)

        if func_name == null: ## asume that developer want to use _ready as talk
            pass
        
        else:
            node_path.callv(func_name, args)
    
    else:
        print(talk, " is not definited")
