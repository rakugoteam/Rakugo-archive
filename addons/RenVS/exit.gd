tool
extends VisualScriptCustomNode

func _get_caption():
	return "Exit Ren"
func _get_input_value_port_count():
	return 0
func _get_output_sequence_port_count():
	return 0
func _get_output_value_port_count():
	return 0
func _has_input_sequence_port():
	return true

func _step(inputs, outputs, start_mode, working_mem):
	return 0 | STEP_NO_ADVANCE_BIT