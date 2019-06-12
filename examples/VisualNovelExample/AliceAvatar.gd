extends RakugoAvatar

var happy = false

func _ready():
	for c in get_children():
		c.hide()

func _on_substate(substate):
	match substate:
		"doubt":
			$PAliceDoubt.show()

		"emabrassed":
			$PAliceEmabrassed.show()

		"happy":
			happy = true
			$PAliceHappy.show()

		"blush":
			if "happy":
				$PAliceHappyBlush.show()

		"teasing":
			$PAliceTeasing.show()

		"worried":
			$PAliceWorried.show()

		"default":
			$PAliceDefault.show()
