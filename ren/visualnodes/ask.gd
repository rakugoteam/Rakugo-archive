tool
extends VisualScriptCustomNode

export var choices = 1 setget set_choices

func set_choices(nc):
	choices=nc
	emit_signal("ports_changed")

func _get_caption():
	return "Ask"
	
func _get_input_value_port_count():
	return choices+2
func _get_input_value_port_type(idx):
	return TYPE_STRING
func _get_input_value_port_name(idx):
	if idx==0:
		return "char id"
	elif idx==1:
		return "Question"
	else:
		return "Choice "+str(idx-1)
func _has_input_sequence_port():
	return true
	
func _get_output_sequence_port_count():
	return choices

func _get_working_memory_size():
	return 1

func _get_output_value_port_count():
	return 0
func _get_output_sequence_port_text(idx):
	return "On Choice "+str(idx+1)

func _step(inputs, outputs, start_mode, working_mem):
	var kwargs=[]
	var ren = Engine.get_main_loop().root.get_node("Window")
	if start_mode==START_MODE_BEGIN_SEQUENCE:
		var m=ren.menu({"how":inputs[0],"what":inputs[1]})
		for x in range(choices):
			var c=ren.choice({"what":inputs[x+2]},m)
			#ren.say({"how":inputs[0],"what":""},c)
		if !ren.get_meta("playing"):
			ren.start()
		else:
			ren.statements[ren.current_statement_id].enter()
		var n= VisualScriptFunctionState.new()
		#n.connect_to_signal(Engine.get_main_loop(),"idle_frame",[])
		n.connect_to_signal(ren,"enter_block",kwargs)
		working_mem[0]=n
		print(n)
		return 0 | STEP_YIELD_BIT
	elif start_mode==START_MODE_RESUME_YIELD:
		print("got choice ",ren.get_meta("last_choice"))
		return ren.get_meta("last_choice")