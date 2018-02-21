tool
extends VisualScriptCustomNode


func _get_caption():
	return "Say"
func _get_category():
	return "Ren"
func _get_input_value_port_count():
	return 2
func _get_input_value_port_name( idx ):
	if idx==0:
		return "char id"
	elif idx==1:
		return "Dialog"
func _get_input_value_port_type( idx ):
	if idx==0 or idx==1:
		return TYPE_STRING


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
	return 1
func _has_input_sequence_port():
	return true


func _step(  inputs,  outputs,  start_mode, working_mem ):
	var s={"how":inputs[0],"what":inputs[1]}
	var kwargs=[]
	var ren = Engine.get_main_loop().root.get_node("Window")
	if start_mode==START_MODE_BEGIN_SEQUENCE:
		ren.say(s)
		if !ren.get_meta("playing"):
			ren.start()
		else:
			ren.statements[ren.current_statement_id].enter()
		var n= VisualScriptFunctionState.new()
		#n.connect_to_signal(Engine.get_main_loop(),"idle_frame",[])
		n.connect_to_signal(ren,"exit_statement",kwargs)
		working_mem[0]=n
		print(n)
		return 0 | STEP_YIELD_BIT
	elif start_mode==START_MODE_RESUME_YIELD:
		#print("got choice ",ren.get_meta("last_choice"))
		return 0
