extends AnimationPlayer
class_name RakugoAnimPlayer

export var auto_define : = true
export var node_id : = ""

var node_link:NodeLink

func _ready() -> void:
	Rakugo.connect("play_anim", self, "_on_play")
	Rakugo.connect("stop_anim", self, "_on_stop")
	
	if node_id.empty():
		node_id = name

	if auto_define:
		node_link = Rakugo.node_link(node_id, get_path())
		
	add_to_group("save", true)

func _on_play(id : String, anim_name : String) -> void:
	if id != node_id:
		return
	
	play(anim_name)

func _on_stop(id : String, reset : bool) -> void:
	if id != node_id:
		return

	if not is_playing():
		return
	
	stop(false)
	
	## walkaround stop(true) don't reset animation
	if reset:
		seek(0, true)
	
func on_save():
	node_link.value["anim_name"] = current_animation
	node_link.value["is_playing"] = is_playing()

func on_load(game_version:String) -> void:
	if node_link.is_playing:
		_on_play(node_id, node_link.anim_name)
