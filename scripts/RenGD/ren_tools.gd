## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##

extends Node

func array_slice(array, from = 0, to = 0):
 	if from > to or from < 0 or to > array.size():
 		return array
 	
 	var _array = array
 
 	for i in range(0, from):
 		_array.remove(i)
     
 	_array.resize(to - from)
 
 	return _array