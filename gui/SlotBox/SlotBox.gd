extends Control

export var slot: PackedScene

var saveslots_dir: String
onready var container := $ScrollGrid/GridContainer
onready var popup := $PopupPanel

var screenshot := Image.new()
var dirhandler := Directory.new()
var filehandler := File.new()
var overwrite := true
var save_name := "new_save"
var file_ext := "res"

signal popup_is_closed

func _ready() -> void:
	update_save_dir()

	var con = popup.get_node("ConfirmOverwrite/HBoxContainer")
	var yes_button = con.get_node("Yes")
	var no_button = con.get_node("No")

	yes_button.connect("pressed", self, "close_popup", [true])
	no_button.connect("pressed", self, "close_popup", [false])

	con = popup.get_node("ConfirmName/HBoxContainer")
	yes_button = con.get_node("Yes")
	no_button = con.get_node("No")

	yes_button.connect("pressed", self, "close_popup", [true])
	no_button.connect("pressed", self, "close_popup", [false])

	con = popup.get_node("ConfirmDelete/HBoxContainer")
	yes_button = con.get_node("Yes")
	no_button = con.get_node("No")

	yes_button.connect("pressed", self, "close_popup", [true])
	no_button.connect("pressed", self, "close_popup", [false])

	var line_edit = popup.get_node("ConfirmName/VBoxContainer/LineEdit")
	line_edit.connect("text_changed", self, "on_save_name_changed")
	line_edit.connect("text_entered", self, "on_save_name_entered")


func delete_save(caller: String, mod: String):
	container.hide()
	var conf = popup.get_node("ConfirmDelete")
	conf.show()
	popup.popup_centered()
	yield(self, "popup_is_closed")
	conf.hide()

	if not overwrite:
		return

	update_save_dir()
	var dir = Directory.new()

	var png_path = saveslots_dir.plus_file(caller + '.png')
	if filehandler.file_exists(png_path):
		Rakugo.debug("remove image")
		dir.remove(png_path)

	var info_path = saveslots_dir.plus_file(caller + '.info')
	if filehandler.file_exists(info_path):
		Rakugo.debug("remove info")
		dir.remove(info_path)

	var save_path = saveslots_dir.plus_file(caller + '.' + file_ext)
	if filehandler.file_exists(save_path):
		Rakugo.debug("remove save")
		dir.remove(save_path)

	if mod == "save":
		savebox()

	if mod == "load":
		loadbox()


func on_save_name_changed(value):
	save_name = value


func on_save_name_entered(value):
	save_name = value
	close_popup(true)


func get_dir_contents(path, ext, ignore = [""]):
	var contents = []
	var dir = Directory.new()

	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while (file_name != ""):
			if !dir.current_is_dir():
				if file_name.ends_with(ext):
					var i = 0

					for ig in ignore:
						if ig in file_name:
							i += 1

					if i == 0:
						contents.append(file_name)

			file_name = dir.get_next()

	else:
		print("An error occurred when trying to access the path.")

	return contents


func close_popup(answer):
	popup.hide()
	container.show()
	overwrite = answer
	emit_signal("popup_is_closed")


func update_save_dir():
	saveslots_dir = "user://" +  Rakugo.save_folder
	file_ext = "res"

	if Rakugo.test_save:
		saveslots_dir = "res://" + Rakugo.save_folder
		file_ext = "tres"

func load_img(path:String) -> ImageTexture:
	var img = Image.new()
	img.load(path)
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	return tex

func new_slot_instance(is_save_mode: bool, filename: String, parent: Node, hide_dl_btn_for_names: PoolStringArray) -> Node:
	var delete_save_mod: String = "save" if is_save_mode else "load"
	var fn_name_to_connect: String = "savepress" if is_save_mode else "loadpress"
	var fn_name_to_disconnect: String = "savepress" if not is_save_mode else "loadpress"

	var s = slot.instance()
	parent.add_child(s)

	var png_path = saveslots_dir.plus_file(filename + '.png')
	if filehandler.file_exists(png_path):
		Rakugo.debug("slot exist, loading image")
		var tex = load_img(png_path)
		s.get_node("Button/TextureRect").texture = tex

	s.get_node("Label").text = filename

	var info_path = saveslots_dir.plus_file(filename + '.info')
	if filehandler.file_exists(info_path):
		filehandler.open(info_path, File.READ)
		s.get_node("Label2").text = filehandler.get_line()
		filehandler.close()

	var b = s.get_node("Button")

	if b.is_connected("pressed", self, fn_name_to_disconnect):
		b.disconnect("pressed", self, fn_name_to_disconnect)

	if !b.is_connected("pressed", self, fn_name_to_connect):
		b.connect("pressed", self, fn_name_to_connect, [filename])

	var bd = s.get_node("Delete")

	if filename in hide_dl_btn_for_names:
		bd.hide()
	else:
		if not bd.is_connected("pressed", self, "delete_save"):
			bd.connect("pressed", self, "delete_save", [filename, delete_save_mod])

	s.show()
	return s

func savebox() -> void:

	var saves = get_dir_contents(saveslots_dir, file_ext,
		["history", "auto", "quick", "back"])

	saves.append("empty")

	for c in container.get_children():
		c.queue_free()

	for x in saves:
		x = x.replace("." + file_ext, "")
		var s = new_slot_instance(true, x, container, PoolStringArray(["empty"]))

	filehandler.close()


func loadbox() -> bool:

	var saves = get_dir_contents(saveslots_dir, file_ext, ["history"])

	for c in container.get_children():
		c.queue_free()

	for x in saves:
		x = x.replace("." + file_ext, "")
		var s = new_slot_instance(false, x, container, PoolStringArray(["empty", "auto"]))

	filehandler.close()
	return true


func savepress(caller: String) -> bool:
	if !dirhandler.dir_exists(saveslots_dir):
		dirhandler.make_dir(saveslots_dir)

	if caller == "empty":
		container.hide()
		var conf = popup.get_node("ConfirmName")
		conf.show()
		popup.popup_centered()
		yield(self, "popup_is_closed")
		conf.hide()
		caller = save_name

	else:
		container.hide()
		var conf = popup.get_node("ConfirmOverwrite")
		conf.show()
		popup.popup_centered()
		yield(self, "popup_is_closed")
		conf.hide()

	if not overwrite:
		return false

	Rakugo.debug(caller)

	if !screenshot:
		return false

	screenshot.flip_y()
	var png_path = saveslots_dir.plus_file(caller + '.png')
	screenshot.save_png(png_path)

	var info_path = saveslots_dir.plus_file(caller + '.info')
	filehandler.open(info_path, File.WRITE)
	var s = Rakugo.get_datetime_str()
	Rakugo.debug(s)
	filehandler.store_line(s)
	Rakugo.debug(["caller:", caller])
	Rakugo.savefile(caller)

	filehandler.close()

	savebox()

	get_parent().in_game()
	get_parent().hide()

	return true


func loadpress(caller: String) -> void:
	if !dirhandler.dir_exists(saveslots_dir):
		dirhandler.make_dir(saveslots_dir)

	if Rakugo.loadfile(caller):
		get_parent().in_game()
		get_parent().hide()
