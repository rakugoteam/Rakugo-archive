extends Resource
class_name Store, "res://addons/Rakugo/icons/save.svg"

export var game_version:String = ""
export var rakugo_version:String = ""
export var properties:Dictionary = {}
var property_signals:Array = []

func _init():
	properties = {}
	property_signals = []

func _get(property):
	if property in self.get_property_list():
		return self[property]
	elif self.properties.has(property):
		return self.properties[property]
	return null


func _set(property, value):
	if property in self.get_property_list():
		self[property] = value
	else:
		self.properties[property] = value
	if property in property_signals:
		emit_signal("on_%s_changed" % property, property, value)
	return true


func connect_on_property_changed(property:String, target:Object, method:String):
	if not self.has_signal("on_%s_changed" % property):
		property_signals.append(property)
		self.add_user_signal("on_%s_changed" % property, [{'name':'property', 'type':TYPE_STRING}, {'name':'value', 'type':TYPE_NIL}])
	self.connect("on_%s_changed" % property, target, method)


func disconnect_on_property_changed(property:String, target:Object, method:String):
	if self.is_connected("on_%s_changed" % property, target, method):
		self.disconnect("on_%s_changed" % property, target, method)


func replace_connections(new_store):
	new_store.property_signals = self.property_signals.duplicate(true)
	for p in property_signals:
		new_store.add_user_signal("on_%s_changed" % p, [{'name':'property', 'type':TYPE_STRING}, {'name':'value', 'type':TYPE_NIL}])
	
	for s in self.get_signal_list():
		for c in self.get_signal_connection_list(s.name):
			new_store.connect(s, c.target, c.method)
			self.disconnect(s, c.target, c.method)
	pass


func duplicate(_deep:bool=true) -> Resource:##Store duplication should always be deep
	var output = .duplicate(true)
	output.script = self.script
	for k in self.properties.keys():
		if _to_duplicate(self.properties[k]):
			print("duplicating %s" % k)
			output.properties[k] = self.properties[k].duplicate(true)
	return output


func _to_duplicate(v):
	var output = false
	output = output or v is Object and v.has_method('duplicate')
	return output
