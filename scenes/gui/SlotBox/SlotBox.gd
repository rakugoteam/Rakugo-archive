extends VBoxContainer

var screenshot = null

var saveslots_dir = "user://saveslot"

func _ready():
	# savebox()
	pass
	
func savebox(saveslotsdir = saveslots_dir + "/"):
	var filehandler = File.new()
	for x in $GridContainer.get_children():
		if filehandler.file_exists(saveslotsdir + x.name + '.png'):
			Ren.debug("slot exist, loading image")
			var img = Image.new()
			img.load(saveslotsdir + x.name + '.png')
			img.flip_y()
			var tex = ImageTexture.new()
			tex.create_from_image(img)

			x.get_node("Button/TextureRect").texture = tex
			filehandler.open(saveslotsdir + x.name + '.info', File.READ)
			x.get_node("Label").text = filehandler.get_line()
			filehandler.close()
		
		var b = x.get_node("Button")
		if !b.is_connected("pressed", self, "savepress"):
			b.connect("pressed", self, "savepress", [x.name])

	filehandler.close()

func loadbox(saveslotsdir = saveslots_dir + "/"):
	var filehandler = File.new()
	for x in $GridContainer.get_children():
		if filehandler.file_exists(saveslotsdir + x.name + '.png'):
			# Ren.debug("slot exist, loading image")
			var img=Image.new()
			img.load(saveslotsdir + x.name + '.png')
			img.flip_y()
			var tex = ImageTexture.new()
			tex.create_from_image(img)

			x.get_node("Button/TextureRect").texture = tex
			
			filehandler.open(saveslotsdir + x.name + '.info', File.READ)
			x.get_node("Label").text = filehandler.get_line()
			filehandler.close()

		else:
			return false
		
		var b = x.get_node("Button")
		if !b.is_connected("pressed", self, "loadpress"):
			b.connect("pressed", self, "loadpress", [x.name])

	filehandler.close()

func savepress(caller):
	var dirhandler = Directory.new()
	var filehandler = File.new()
	if !dirhandler.dir_exists(saveslots_dir):
		dirhandler.make_dir(saveslots_dir)

	Ren.debug(caller)
	if screenshot == null:
		return false

	screenshot.save_png(saveslots_dir + "/" + caller + '.png')
	filehandler.open(saveslots_dir + "/" + caller + '.info', File.WRITE)
	var s = Ren.get_datetime_str()
	Ren.debug(s)
	filehandler.store_line(s)
	Ren.debug(["caller:", caller])
	Ren.savefile(caller)

	filehandler.close()
	
	savebox()
	
func loadpress(caller):
	var dirhandler = Directory.new()
	var filehandler = File.new()
	if !dirhandler.dir_exists(saveslots_dir):
		dirhandler.make_dir(saveslots_dir)

	if Ren.loadfile(caller):
		get_parent().in_game()
		get_parent().hide()
	
