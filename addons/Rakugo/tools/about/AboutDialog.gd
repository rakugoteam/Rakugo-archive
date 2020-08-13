tool
extends AcceptDialog

func _on_WebSiteButton_pressed():
	OS.shell_open("https://rakugoteam.github.io/")


func _on_BugButton_pressed():
	OS.shell_open("https://github.com/rakugoteam/Rakugo/labels/bug")
