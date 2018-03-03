tool
extends VisualScriptCustomNode


func _get_caption():
	return "Start"
func _get_input_value_port_count():
	return 0
func _get_input_value_port_name( idx ):
	return
func _get_input_value_port_type( idx ):
	return


func _get_output_sequence_port_count():
	return 1
func _get_output_sequence_port_text(  idx ):
	return ""
func _get_output_value_port_count():
	return 0
func _get_output_value_port_name(  idx ):
	return ""
func _get_output_value_port_type(  idx ) :
	return 0
func _get_text():
	return ""
func _get_working_memory_size():
	return []
func _has_input_sequence_port():
	return true
func _step(  inputs,  outputs,  start_mode, working_mem ):
	var Ren= Engine.get_main_loop().root.get_node("Window")
	Ren.start()
	return 0
