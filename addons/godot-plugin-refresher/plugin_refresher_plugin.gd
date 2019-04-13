tool
extends EditorPlugin

const PluginRefresherScn = preload("plugin_refresher.tscn")

var refresher

func _enter_tree():
	refresher = PluginRefresherScn.instance()
	add_control_to_container(CONTAINER_TOOLBAR, refresher)
	
	var efs = get_editor_interface().get_resource_filesystem()
	efs.connect("filesystem_changed", self, "_on_filesystem_changed")
	
	refresher.connect("request_refresh_plugin", self, "_on_request_refresh_plugin")

func _exit_tree():
	remove_control_from_container(CONTAINER_TOOLBAR, refresher)
	refresher.free()

func _on_filesystem_changed():
	if refresher:
		refresher.reload_items()

func _on_request_refresh_plugin(p_name):
	print("Refreshing plugin: ", p_name)
	get_editor_interface().set_plugin_enabled(p_name, false)
	get_editor_interface().set_plugin_enabled(p_name, true)