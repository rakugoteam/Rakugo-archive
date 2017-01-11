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

func set_label_current_label(label):
     if label in labels.keys():
        label_name = label
    
     else:
        print(label, " is not definited")


func jump(label, args = []):

    if label in labels.keys():
        label_name = label
        if scene_path != current_scene_path:
            goto_scene(scene_path)
            current_scene_path = scene_path

        if node == null: ## asume that developer want to use parent of scene
            node = current_scene
        
        else:
            node = get_node(current_scene.get_path() + "/" + node_path)

        if fun == null: ## asume that developer want to use _ready as label
            pass
        
        else:
            node.callv(func_name, args)
    
    else:
        print(label, " is not definited")
