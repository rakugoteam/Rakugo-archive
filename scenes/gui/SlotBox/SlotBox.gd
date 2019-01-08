extends VBoxContainer

const weekdays={
	0:'Sunday',
	1:'Monday',
	2:'Tuesday',
	3:'Wednesday',
	4:'Thrusday',
	5:'Friday',
	6:'Saturday'
}

const months={
	1:'January',
	2:'February',
	3:'March',
	4:'April',
	5:'May',
	6:'June',
	7:'July',
	8:'August',
	9:'September',
	10:'October',
	11:'November',
	12:'December'
}

var screenshot = null

func _ready():
	#savebox()
	pass
	
func savebox(saveslotsdir = "user://saveslot/"):
	var filehandler = File.new()
	for x in $GridContainer.get_children():
		if filehandler.file_exists(saveslotsdir + x.name + '.png'):
			Ren.debug("slot exist, loading image")
			var img = Image.new()
			img.load(saveslotsdir + x.name + '.png')
			var tex = ImageTexture.new()
			tex.create_from_image(img)
			# x.get_node("Panel/TextureRect").texture = tex
			x.get_node("Button/TextureRect").texture = tex
			filehandler.open(saveslotsdir + x.name + '.info', File.READ)
			x.get_node("Label").text = filehandler.get_line()
			filehandler.close()
		
		var b = x.get_node("Button")
		if !b.is_connected("pressed", self, "savepress"):
			b.connect("pressed", self, "savepress", [x.name])

			# for y in x.get_children():
			# 	b = y.get_node("Button")
			# 	b.connect("pressed", self, "savepress", [x.name])

		# if !x.is_connected("pressed", self, "savepress"):
		# 	x.connect("pressed", self, "savepress", [x])

		# 	for y in x.get_children():
		# 		y.connect("pressed", self, "savepress", [x])

	filehandler.close()

func loadbox(saveslotsdir = "user://saveslot/"):
	var filehandler = File.new()
	for x in $GridContainer.get_children():
		if filehandler.file_exists(saveslotsdir + x.name + '.png'):
			#Ren.debug("slot exist, loading image")
			var img=Image.new()
			img.load(saveslotsdir + x.name + '.png')
			var tex = ImageTexture.new()
			tex.create_from_image(img)
			tex.create_from_image(img)
			# x.get_node("Panel/TextureRect").texture = tex
			x.get_node("Button/TextureRect").texture = tex
			
			filehandler.open(saveslotsdir + x.name + '.info', File.READ)
			x.get_node("Label").text = filehandler.get_line()
			filehandler.close()

		else:
			return false
		
		var b = x.get_node("Button")
		if !b.is_connected("pressed", self, "loadpress"):
			b.connect("pressed", self, "loadpress", [x.name])

			# for y in x.get_children():
			# 	print(y.name)
			# 	b = y.get_node("Button")
			# 	b.connect("pressed", self, "loadpress", [x.name])

		# if !x.is_connected("pressed", self, "loadpress"):
		# 	x.connect("pressed", self, "loadpress", [x])

		# 	for y in x.get_children():
		# 		y.connect("pressed", self, "loadpress", [x])


	filehandler.close()

func savepress(caller): # (input, caller):
	var dirhandler = Directory.new()
	var filehandler = File.new()
	if !dirhandler.dir_exists("user://saveslot"):
		dirhandler.make_dir("user://saveslot")

	# if input is InputEventMouseButton:
	# 	if input.pressed:
	Ren.debug(caller)
	if screenshot == null:
		return false

	screenshot.save_png("user://saveslot/" + caller + '.png')
	filehandler.open("user://saveslot/" + caller + '.info', File.WRITE)
	var d = OS.get_datetime()
	var s = weekdays[d['weekday']] + ' ' + months[d['month']] + ' ' + str(d['day']) + ', ' + str(d['hour']) + ':' + str(d['minute'])
	Ren.debug(s)
	filehandler.store_line(s)
	Ren.debug(["caller:", caller])
	Ren.savefile(caller)

	filehandler.close()
	
	savebox()
	
func loadpress(caller): # (input, caller):
	var dirhandler = Directory.new()
	var filehandler = File.new()
	if !dirhandler.dir_exists("user://saveslot"):
		dirhandler.make_dir("user://saveslot")

	# if input is InputEventMouseButton:
	# 	if input.pressed:
	if Ren.loadfile(caller):
		get_parent().in_game()
		get_parent().hide()
	
	
	
