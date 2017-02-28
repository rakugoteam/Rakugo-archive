## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##

extends HBoxContainer

onready var ren = get_node("/root/Window")

onready var Back    = get_node("Back")
onready var History = get_node("History")
onready var Skip    = get_node("Skip")
onready var Auto    = get_node("Auto")
onready var Save    = get_node("Save")
onready var QSave   = get_node("QSave")
onready var QLoad   = get_node("QLoad")
onready var Prefs   = get_node("Prefs")


func _ready():

	ren.connect("statement_changed", self, "on_statement_changed")

	Back.connect("pressed", ren, "prev_statement")
	# Skip.connect("toggled", ren, "skip()")
	# Auto.connect("toggled", ren, "auto()")
	# History.connect("pressed", self, "print", ["History"])
	# Save.connect("pressed", self, "print", ["Save"])
	# QSave.connect("pressed", self, "print", ["QSave"])
	# QLoad.connect("pressed", self, "print", ["QLoad"])
	# Prefs.connect("pressed", self, "print", ["Prefs"])

func on_statement_changed():
	if ren.snum == 0 or not ren.can_roll:
		Back.set_disabled(true)
	
	else:
		Back.set_disabled(false)
	
	if ren.was_seen_id(ren.snum+1) and ren.can_roll:
		Skip.set_disabled(false)
	
	else:
		Skip.set_disabled(true)
	