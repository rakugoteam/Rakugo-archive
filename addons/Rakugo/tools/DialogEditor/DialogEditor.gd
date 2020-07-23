extends Panel

onready var graph_edit = $VBoxContainer/HBoxContainer/GraphEdit

var history := []

func _ready():
	graph_edit.connect("connection_request", self, "on_connect")
	graph_edit.connect("disconnection_request", self, "on_disconnect")


func on_connect(from, from_slot, to, to_slot):
	graph_edit.connect_node(from, from_slot, to, to_slot)


func on_disconnect(from, from_slot, to, to_slot):
	graph_edit.disconnect_node(from, from_slot, to, to_slot)
