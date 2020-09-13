extends AcceptDialog

func _ready():
	self.get_ok().text = "Yes"
	self.add_cancel("No")
