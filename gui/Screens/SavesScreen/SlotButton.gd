extends Button

#This script is to always keep the left line on hovering a slot the same size as the screenshot panel, mimicking Ren'Py

export var screenshot_panel_path:NodePath = ''
onready var screenshot_panel:Panel = get_node(screenshot_panel_path)

func update_line_height():
	var style_box_line:StyleBoxLine = self.get("custom_styles/hover")
	style_box_line.grow_end = screenshot_panel.rect_size.y - self.rect_size.y


func _on_screenshot_panel_resized():
	update_line_height()


func _on_screenshot_panel_visibility_changed():
	if screenshot_panel.visible:
		update_line_height()
