extends Node


var blocks:Array = []


func _restore(_store):
	unblock_all()


func _step():
	unblock_all()


func block(id:String):
	blocks.append(id)


func unblock(id:String):
	blocks.erase(id)


func unblock_all():
	while blocks:
		blocks.remove(0)


func is_blocking() -> bool:
	return blocks.size() > 0
