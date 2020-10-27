extends Resource
class_name HistoryEntry

export var character:Resource
export var text:String
export var parameters:Dictionary

func init(_character:Character, _text:String, _parameters:Dictionary):#Cannot use _init as it makes casting impossible
	character = _character
	text = _text
	parameters = _parameters


func duplicate(_deep:bool=true) -> Resource:##Store duplication should always be deep
	var output = .duplicate(true)
	for p in self.get_property_list():
		if p.type == TYPE_DICTIONARY or p.type == TYPE_ARRAY:
			var a = output.get(p.name)
			output.set(p.name, a.duplicate(true))
	return output
