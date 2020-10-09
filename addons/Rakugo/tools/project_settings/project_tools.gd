tool
class_name ProjectTools
extends Reference
# author: willnationsdev
# license: MIT
# description: A utility for any features useful in the context of a Godot Project.


static func set_setting(p_name: String, p_default_value, p_pinfo: PropertyInfo) -> void:
	p_pinfo.name = p_name
	if not ProjectSettings.has_setting(p_name):
		ProjectSettings.set_setting(p_name, p_default_value)
	ProjectSettings.add_property_info(p_pinfo.to_dict())
	ProjectSettings.set_initial_value(p_name, p_default_value)
