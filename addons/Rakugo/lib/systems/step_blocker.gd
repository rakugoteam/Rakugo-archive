extends Node


var blocks:Dictionary = {}


func _restore(_store):
	unblock_all()


func _step():
	unblock_all()


func block(id:String):
	if id in blocks:
		blocks[id] += 1
	else:
		blocks[id] = 1


func simple_block(id:String):
	blocks[id] = 1


func unblock(id:String):
	if id in blocks:
		if blocks[id] > 1:
			blocks[id] += -1
		else:
			blocks.erase(id)


func unblock_all():
	blocks = {}


func set_block(id:String, value:int):
	if value > 0:
		blocks[id] = value
	else:
		blocks.erase(id)


func has_block(id:String):
	return blocks.has(id)


func get_block_count(id:String):
	return blocks.get(id, 0)


func get_blocks():
	return blocks.keys()


func is_blocking() -> bool:
	return not blocks.empty()
