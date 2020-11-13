extends Panel

export var slot: PackedScene
export var dummy_slot: PackedScene

export var popup_path:NodePath = 'ConfirmationPopup'
onready var popup := get_node(popup_path)

var screenshot := Image.new()
var dir := Directory.new()
var file = File.new()


export var default_save_name := "save"
var file_ext := "res"

var save_mode = true setget set_mode
var save_list:Array = []
var save_pages:Dictionary = {}


var use_pages:bool = false

signal load_file

signal mode_changed(save_mode)
signal clear_save_slots()
signal add_save_slot(save_slot)
signal page_changed()

func _ready() -> void:
	use_pages = Settings.get('rakugo/saves/save_screen_layout') == "save_pages"
	
	for e in get_tree().get_nodes_in_group("save_screen_page_ui_element"):
		e.visible = use_pages
	for e in get_tree().get_nodes_in_group("save_screen_scroll_ui_element"):
		e.scroll_vertical_enabled = not use_pages
		
	if use_pages:
		Settings.get('rakugo/saves/current_page', 1)#Set the default
		#_on_change_page(1, 0)
	return

func set_mode(mode):
	save_mode = mode
	emit_signal("mode_changed", mode)
	_on_visibility_changed()

func update_save_pages():
	save_pages = {}
	var page_re = RegEx.new()
	page_re.compile("^([0-9]+)_([0-9]+)_(.+)")
	for save in save_list:
		var result = page_re.search(save)
		if result:
			save_pages[Vector2(int(result.get_string(1)), int(result.get_string(2)))] = result.get_string(3)
	pass

func update_save_list(ignores = [""]):
	var contents = []
	if dir.open(Rakugo.StoreManager.get_save_folder_path()) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while (file_name != ""):
			if !dir.current_is_dir():
				if file_name.ends_with(file_ext):
					var i = false

					for ig in ignores:
						if ig in file_name:
							i = true
							break

					if not i:
						contents.append(file_name.replace("." + file_ext, ""))

			file_name = dir.get_next()

	else:
		print("An error occurred when trying to access the path.")
	save_list = contents
	return contents
	
	
func update_grid(_save_mode = null):
	if not _save_mode == null:
		save_mode = _save_mode

	var saves:Array
	if save_mode:
		saves = update_save_list(["history", "auto", "quick", "back"])
		saves.append("empty")
	else:
		saves = update_save_list(["history"])
	
	
	
	if use_pages:
		update_save_pages()
		populate_grid_page()
	else:
		populate_grid(saves)

	
func populate_grid(saves):
	emit_signal("clear_save_slots")
	
	for save in saves:
		emit_signal("add_save_slot", new_slot_instance(save, Vector2.ZERO, save in ["empty", "auto"]))
		
func populate_grid_page():
	emit_signal("clear_save_slots")
	

	var saves = []
	var current_page = Settings.get('rakugo/saves/current_page', 1) 
	for i in range(6):
		var index = Vector2(current_page, i)
		if save_pages.has(index):
			saves.append(new_slot_instance(save_pages[index], index, false))
		else:
			if save_mode:
				saves.append(new_slot_instance("empty", index, true))
			else:
				saves.append(dummy_slot.instance())
	
	for x in saves:
		emit_signal("add_save_slot", x)

		
func new_slot_instance(filename: String, page_index:Vector2, hide_dl_btn:bool) -> Node:
	var s = slot.instance()
	
	s.init(filename, page_index, hide_dl_btn)

	s.connect("select_save", self, "_on_save_select")
	if not hide_dl_btn:
		s.connect("delete_save", self, "_on_delete_save")

	s.show()
	return s

func _on_delete_save(save_filename):
	popup.delete_confirm()
	if not yield(popup, "return_output"):
		return false

	var png_path = Rakugo.StoreManager.get_save_path(save_filename, true)+".png"
	if file.file_exists(png_path):
		Rakugo.debug("remove image")
		dir.remove(png_path)

	var save_path = Rakugo.StoreManager.get_save_path(save_filename)
	if file.file_exists(save_path):
		Rakugo.debug("remove save")
		dir.remove(save_path)
	
	update_grid()

func _on_save_select(save_filename, page_index):
	if save_mode: 
		if use_pages:
			save_page_save(save_filename, page_index)
		else:
			save_save(save_filename)
	else:
		if use_pages:
			save_filename = "%d_%d_%s" % [page_index.x, page_index.y, save_filename]
		load_save(save_filename)

func save_save(caller: String) -> bool:
	var new_save = false
	if caller == "empty":
		if Settings.get('rakugo/saves/skip_naming', true):
			caller = get_next_iterative_name(default_save_name)
		else:
			new_save = true
			popup.name_save_confirm()
			var chosen_name = yield(popup, "return_output")
			if not chosen_name is String:#explicit check needed as "" doesn't count as true
				return false
			elif not chosen_name:
				caller = get_next_iterative_name(default_save_name)
			else:
				caller = chosen_name
 
	if caller in save_list:
		popup.overwrite_confirm(new_save)
		if not yield(popup, "return_output"):
			if new_save:
				caller = get_next_iterative_name(caller)
			else:
				return false

	Rakugo.debug(caller)

	if !screenshot:
		return false

	#screenshot.flip_y()
	var png_path = Rakugo.StoreManager.get_save_path(caller, true) + '.png'
	screenshot.save_png(png_path)

	Rakugo.debug(["caller:", caller])
	Rakugo.save_game(caller)

	update_grid()

	#get_parent().in_game()
	return true
	
func save_page_save(caller: String, page_index:Vector2) -> bool:
	if page_index in save_pages:
		popup.overwrite_confirm()
		if not yield(popup, "return_output"):
			return false

	if Settings.get('rakugo/saves/skip_naming', true):
		caller = default_save_name
	else:
		popup.name_save_confirm()
		var chosen_name = yield(popup, "return_output")
		if not chosen_name is String:#explicit check needed as "" doesn't count as true
			return false
		elif not chosen_name:
			caller = default_save_name
		else:
			caller = chosen_name

	caller = "%s_%s_%s" % [str(page_index.x), str(page_index.y), caller]

	Rakugo.debug(caller)

	if !screenshot:
		return false

	#screenshot.flip_y()
	var png_path = Rakugo.StoreManager.get_save_path(caller, true) + '.png'
	screenshot.save_png(png_path)

	Rakugo.debug(["caller:", caller])
	Rakugo.save_game(caller)

	update_grid()
	#get_parent().in_game()
	return true

func get_next_iterative_name(file_name):
	var iteration_re = RegEx.new()
	iteration_re.compile("(.*)([0-9]+)$")
	var result = iteration_re.search(file_name)
	
	var radical = file_name
	var iteration = 0
	if result:
		radical = result.get_string(1)
		iteration = int(result.get_string(2))
		iteration += 1
	else:
		radical = radical + "_"

	while (radical+str(iteration)) in save_list:
		iteration += 1
	return (radical+str(iteration))
	

func load_save(caller: String) -> void:
	if Rakugo.load_game(caller):
		emit_signal("load_file")


func _on_visibility_changed():
	if visible:
		if use_pages:
			_on_change_page(Settings.get('rakugo/saves/current_page', 1), 0)
		else:
			update_grid()


func _on_change_page(page, incremental_change):
	match page:
		-1:
			page = "Q"
		-2:
			page = "A"
	match page:
		0:
			var value = clamp(Settings.get('rakugo/saves/current_page', 1) + incremental_change, -2, 1000)
			Settings.set('rakugo/saves/current_page', value)
		"Q":
			Settings.set('rakugo/saves/current_page', -1)
		"A":
			Settings.set('rakugo/saves/current_page', -2)
		_:
			Settings.set('rakugo/saves/current_page', int(page))
	emit_signal("page_changed")
	update_grid()

func split_paged_savename(savename):
	var page_re = RegEx.new()
	page_re.compile("^([0-9]+)_([0-9]+)_(.+)")
	var result = page_re.search(savename)
	if result:
		return [result.get_string(0), result.get_string(1), result.get_string(2), result.get_string(3)]
	else:
		return []
