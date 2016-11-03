extends Panel

var wsize = Vector2(0, 0)
var mcsize = Vector2(0, 0)
onready var MainContainer = get_node("VBoxContainer") 

func _ready():
	resize()
	set_process(true)

func resize():
	#resize MainWindow
	wsize = OS.get_window_size()
	set_size(wsize)
	
	#resize MainCotainer
	mcsize = MainContainer.get_size()
	MainContainer.set_size(wsize)
	





