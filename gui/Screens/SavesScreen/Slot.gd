extends Control

signal delete_save(name)
signal select_save(name, page_index)


signal set_screenshot(screenshot)
signal set_datetime(datetime)
signal set_save_name(save_name)
signal set_delete_button(visibility)

var file := File.new()

var save_name:String = ""
var save_page_index:Vector2 = Vector2.ZERO
var screenshot:Texture = null

func init(name:String, page_index:Vector2, hide_delete:bool = false):
	save_name = Rakugo.StoreManager.get_save_name(name)
	save_page_index = page_index
	
	var filename = save_name
	if page_index:
		filename = "%s_%s_%s" % [str(save_page_index.x), str(save_page_index.y), save_name]
	
	if not hide_delete:
		var png_path = Rakugo.StoreManager.get_save_path(filename + ".png", true)
		if file.file_exists(png_path):
			Rakugo.debug("slot exist, loading image")
			set_screenshot(load(png_path))
	else:
		hide_delete_button()
	
	
	set_save_name(save_name)

	if save_name == "empty":
		set_datetime(0)
	else:
		set_datetime(file.get_modified_time(Rakugo.StoreManager.get_save_path(filename)))
	


func _on_save_select():
	emit_signal("select_save", save_name, save_page_index)
	
func _on_save_delete():
	if save_page_index:
		emit_signal("delete_save", "%s_%s_%s" % [str(save_page_index.x), str(save_page_index.y), save_name])
	else:
		emit_signal("delete_save", save_name)


func set_screenshot(texture):
	self.screenshot = texture
	emit_signal("set_screenshot", texture)

func set_datetime(datetime):
	emit_signal("set_datetime", datetime)
	
func set_save_name(savename):
	emit_signal("set_save_name", savename)
	
func hide_delete_button():
	emit_signal("set_delete_button", false)
