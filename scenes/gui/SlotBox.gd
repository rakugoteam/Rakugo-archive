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


var screenshot=null
func _ready():
	#savebox()
	pass
	
func savebox(saveslotsdir="user://saveslot/"):
	var filehandler=File.new()
	for x in $GridContainer.get_children():
		if filehandler.file_exists(saveslotsdir+x.name+'.png'):
			print("slot exist, loading image")
			var img=Image.new()
			img.load(saveslotsdir+x.name+'.png')
			var tex=ImageTexture.new()
			tex.create_from_image(img)
			x.get_node("Panel/TextureRect").texture=tex
			filehandler.open(saveslotsdir+x.name+'.info',File.READ)
			x.get_node("Label").text=filehandler.get_line()
			filehandler.close()
		if !x.is_connected("gui_input",self,"savepress"):
			x.connect("gui_input",self,"savepress",[x])
			for y in x.get_children():
				y.connect("gui_input",self,"savepress",[x])
	filehandler.close()

func loadbox(saveslotsdir="user://saveslot/"):
	var filehandler=File.new()
	for x in $GridContainer.get_children():
		if filehandler.file_exists(saveslotsdir+x.name+'.png'):
			#print("slot exist, loading image")
			var img=Image.new()
			img.load(saveslotsdir+x.name+'.png')
			var tex=ImageTexture.new()
			tex.create_from_image(img)
			x.get_node("Panel/TextureRect").texture=tex
			filehandler.open(saveslotsdir+x.name+'.info',File.READ)
			x.get_node("Label").text=filehandler.get_line()
			filehandler.close()
		else:
			return false
		if !x.is_connected("gui_input",self,"loadpress"):
			x.connect("gui_input",self,"loadpress",[x])
			for y in x.get_children():
				y.connect("gui_input",self,"loadpress",[x])
	filehandler.close()

func savepress(input,caller):
	var dirhandler=Directory.new()
	var filehandler=File.new()
	if !dirhandler.dir_exists("user://saveslot"):
		dirhandler.make_dir("user://saveslot")

	if input is InputEventMouseButton:
		if input.pressed:
			print(caller.name)
			if screenshot==null:
				return false
			screenshot.save_png("user://saveslot/"+caller.name+'.png')
			filehandler.open("user://saveslot/"+caller.name+'.info',File.WRITE)
			var d=OS.get_datetime()
			var s=weekdays[d['weekday']]+' '+months[d['month']]+' '+str(d['day'])+', '+str(d['hour'])+':'+str(d['minute'])
			print(s)
			filehandler.store_line(s)
			print("caller.name: ", caller.name)
			Ren.savefile(caller.name)
	filehandler.close()
	
	savebox()
	
func loadpress(input,caller):
	var dirhandler=Directory.new()
	var filehandler=File.new()
	if !dirhandler.dir_exists("user://saveslot"):
		dirhandler.make_dir("user://saveslot")

	if input is InputEventMouseButton:
		if input.pressed:
			if Ren.loadfile(caller.name):
				get_parent()._on_Return_pressed()
	
