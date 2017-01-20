## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.05 ##
## License MIT ##
## Copyright (c) 2016 Jeremi Biernacki ##

extends Node

var label_name
var scene_path
var current_scene
var current_scene_path
var node_path
var func_name

var labels = {}

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


func jump(label, args = []):

    ## this need to be rewrite

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
        print(label, " is not definited")
