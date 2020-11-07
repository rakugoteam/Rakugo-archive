extends Resource
class_name HistoryEntry

export var character_tag:String
export var text:String
export var parameters:Dictionary

func init(_character_tag:String, _text:String, _parameters:Dictionary):#Cannot use _init as it makes casting impossible
	character_tag = _character_tag
	text = _text
	parameters = _parameters


func duplicate(_deep:bool=true) -> Resource:##Store duplication should always be deep
	var output = .duplicate(true)
	output.script = self.script
	return output
