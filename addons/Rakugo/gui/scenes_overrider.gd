extends Node
class_name ScenesOverrider
export (String, FILE, "*.tscn") var this_scene_path := ""
export(String, DIR) var override_dir := ""

var file = File.new()
var dir = Directory.new()

var this_scene := this_scene_path.get_file()
var this_dir := this_scene_path.get_base_dir()
var override_scenes := []
var loaded_scenes := []
var def_scenes := []


func _ready():
	def_scenes = get_scenes(this_dir)
	
	if !override_dir.is_valid_filename():
		override_scenes = get_scenes(override_dir)
	
	add_default_scenes()
	add_extra_scenes()

func add_default_scenes() -> void:
	for path in def_scenes:
		
		if path == this_scene_path:
			continue
		
		path = override_default_scene(path)
		
		add_scene(path)
		loaded_scenes.append(path)


func override_default_scene(path:String) -> String: 
	if !override_dir.empty():
		for o_path in override_scenes:
			if path.get_file() == o_path.get_file():
				return o_path
				
	return path

func add_extra_scenes() -> void:
	if !override_dir.empty():
		for o_path in override_scenes:
			
			if o_path in loaded_scenes:
				continue
			
			add_scene(o_path)
			loaded_scenes.append(o_path)


func add_scene(path:String) -> void:
	var scene := load(path)
	var node = scene.instance()
	get_parent().call_deferred("add_child", node)


func get_scenes(path:String) -> Array:
	var arr := []
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				var f := path.plus_file(file_name)
				Rakugo.debug(["Found scene:", f])
				arr.append(f)
			file_name = dir.get_next()
	else:
		prints("An error occurred when trying to access", path)
	
	return arr


