tool
extends Button

export(PackedScene) var SceneLinkEdit: PackedScene
export(NodePath) var box_path: NodePath
onready var box:BoxContainer = get_node(box_path)


func _ready() -> void:
	connect("pressed", self, "_on_pressed")


func _on_pressed() -> void:
	var nsle = SceneLinkEdit.instance()
	box.add_child(nsle)

