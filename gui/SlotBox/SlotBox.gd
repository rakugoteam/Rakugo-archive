extends Control

export var slot: PackedScene

onready var saveslots_dir : String = "res://" + Rakugo.save_folder
onready var container := $ScrollGrid/GridContainer
onready var popup := $PopupPanel

var screenshot := Image.new()
var dirhandler := Directory.new()
var filehandler := File.new()
var overwrite := true
var save_name := "new_save"

signal popup_is_closed

func _ready() -> void:
	connect("visibility_changed", self, "_on_visibility_changed")

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

func delete_save(caller : String, mod : String):
	container.hide()
	var conf = popup.get_node("ConfirmDelete")
	conf.show()
	popup.popup_centered()
	yield(self, "popup_is_closed")
	conf.hide()

	if not overwrite:
		return

	var dir = Directory.new()
	var saveslotsdir = saveslots_dir + "/"

	if filehandler.file_exists(saveslotsdir + caller + '.png'):
		Rakugo.debug("remove image")
		var img = saveslotsdir + caller + '.png'
		dir.remove(img)

	if filehandler.file_exists(saveslotsdir + caller + '.info'):
		Rakugo.debug("remove info")
		var info = saveslotsdir + caller + '.info'
		dir.remove(info)

	if filehandler.file_exists(saveslotsdir + caller + '.tres'):
		Rakugo.debug("remove save")
		var save = saveslotsdir + caller + '.tres'
		dir.remove(save)

	if mod == "save":
		savebox()

	if mod == "load":
		loadbox()

func _on_visibility_changed():
	if visible:
		$ScrollGrid.scroll_vertical = settings.saves_scroll
		return

	settings.saves_scroll = $ScrollGrid.scroll_vertical

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

func savebox(saveslotsdir : = saveslots_dir + "/") -> void:
	var saves = get_dir_contents(saveslots_dir, "tres",
		["history", "auto", "quick", "back"])

	saves.append("empty")

	for c in container.get_children():
		c.queue_free()

	for x in saves:
		x = x.replace(".tres", "")
		var s = slot.instance()
		container.add_child(s)

		if filehandler.file_exists(saveslotsdir + x + '.png'):
			Rakugo.debug("slot exist, loading image")
			var tex = load(saveslotsdir + x + '.png')
			s.get_node("Button/TextureRect").texture = tex

		s.get_node("Label").text = x

		if filehandler.file_exists(saveslotsdir + x + '.info'):
			filehandler.open(saveslotsdir + x + '.info', File.READ)
			s.get_node("Label2").text = filehandler.get_line()
			filehandler.close()

		var b = s.get_node("Button")

		if b.is_connected("pressed", self, "loadpress"):
			b.disconnect("pressed", self, "loadpress")

		if !b.is_connected("pressed", self, "savepress"):
			b.connect("pressed", self, "savepress", [x])

		var bd = s.get_node("Delete")

		if x in ["empty"]:
			bd.hide()

		else:
			if not bd.is_connected("pressed", self, "delete_save"):
				bd.connect("pressed", self, "delete_save", [x, "save"])

		s.show()

	filehandler.close()

func loadbox(saveslotsdir : = saveslots_dir + "/") -> bool:
	var saves = get_dir_contents(saveslots_dir, "tres", ["history"])

	for c in container.get_children():
		c.queue_free()

	for x in saves:
		x = x.replace(".tres", "")
		var s = slot.instance()
		container.add_child(s)

		if filehandler.file_exists(saveslotsdir + x + '.png'):
			Rakugo.debug("slot exist, loading image")
			var tex = load(saveslotsdir + x + '.png')
			s.get_node("Button/TextureRect").texture = tex

		s.get_node("Label").text = x

		if filehandler.file_exists(saveslotsdir + x + '.info'):
			filehandler.open(saveslotsdir + x + '.info', File.READ)
			s.get_node("Label2").text = filehandler.get_line()
			filehandler.close()

		var b = s.get_node("Button")

		if b.is_connected("pressed", self, "savepress"):
			b.disconnect("pressed", self, "savepress")

		if !b.is_connected("pressed", self, "loadpress"):
			b.connect("pressed", self, "loadpress", [x])

		var bd = s.get_node("Delete")

		if x in ["empty", "auto"]:
			bd.hide()

		else:
			if not bd.is_connected("pressed", self, "delete_save"):
				bd.connect("pressed", self, "delete_save", [x, "load"])

		s.show()

	filehandler.close()
	return true

func savepress(caller : String) -> bool:
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
	screenshot.save_png(saveslots_dir + "/" + caller + '.png')
	filehandler.open(saveslots_dir + "/" + caller + '.info', File.WRITE)
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

func loadpress(caller : String) -> void:
	if !dirhandler.dir_exists(saveslots_dir):
		dirhandler.make_dir(saveslots_dir)

	if Rakugo.loadfile(caller):
		get_parent().in_game()
		get_parent().hide()
