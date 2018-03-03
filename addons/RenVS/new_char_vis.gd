tool
extends VisualScriptCustomNode

func _has_input_sequence_port():
	return true
func _get_caption():
	return "New Character"

func _get_input_value_port_count():
	return 3
	
func _get_input_value_port_type(idx):
	return TYPE_STRING
	
func _get_output_sequence_port_count():
	return 1
	
func _get_input_value_port_name(idx):
	if idx==0:
		return "Char id"
	elif idx==1:
		return "Name "
	elif idx==2:
		return "Avatar"

func _step(inputs, outputs, start_mode, working_mem):
	print(inputs)
	var Ren = Engine.get_main_loop().root.get_node("Window")
	Ren.character(inputs[0],{"name":inputs[1],"avatar":inputs[2]})
	return 0 