## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##

extends Node

var label_name
var scene_path
var current_scene
var current_scene_path
var node_path
var func_name

var labels = {}


func _ready():    
    ## code borrow from:
    ## http://docs.godotengine.org/en/stable/tutorials/step_by_step/singletons_autoload.html
    var root = get_tree().get_root()
    current_scene = root.get_child( root.get_child_count() -1 )
    
    set_process_input(true)


func _Elabel(label):
    print(label, " is not definited")


func _label(label, sc_path, n_path = null, f_name = null):
    label_name = label
    scene_path = sc_path
    node_path = n_path
    func_name = f_name


func label(label, sc_path, n_path = null, f_name = null):
    _label(label, sc_path, n_path, f_name)
    labels[label] = [sc_path, n_path, f_name]


func set_label_current_label(label):
    if label in labels.keys():
        var l = labels[label]
        _label(label, l[0], l[1], l[2])
    
    else:
        _Elabel(label)


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
    get_tree().set_current_scene( current_scene )


func jump(label, args = []):

    if label in labels.keys():
        label_name = label
        if scene_path != current_scene_path:
            goto_scene(scene_path)
            current_scene_path = scene_path

        if node_path == null: ## asume that developer want to use parent of scene
            node_path = current_scene
        
        else:
            node_path = get_node(current_scene.get_path() + "/" + node_path)

        if func_name == null: ## asume that developer want to use _ready as label
            pass
        
        else:
            node_path.callv(func_name, args)
    
    else:
        _Elabel(label)
