extends VBoxContainer

export(PackedScene) var HistoryItemTemplate: PackedScene
onready var HistoryItem := load(HistoryItemTemplate.resource_path)


func _ready() -> void:
	connect("visibility_changed", self, "_on_visibility_changed")


func _on_visibility_changed() -> void:
	if not visible:
		return
	
	for c in self.get_children():
		remove_child(c)
	var new_item:Control = null
	for i in range(Rakugo.store.history.size()-1, -1, -1): #Inverting the array without data manipulation
		new_item = HistoryItem.instance()
		new_item.init(Rakugo.store.history[i])
		add_child(new_item)
	get_parent().call_deferred('scroll_to_bottom')
