tool
extends VisualScriptCustomNode

export var allow_back = true

func _get_caption():
	return "Input "
	
func _has_input_sequence_port():
	return true

func _get_output_sequence_port_count():
	return 1
	
func _get_input_value_port_count():
	return 4
	
func _get_input_value_port_type(idx):
	return TYPE_STRING
	
func _get_input_value_port_name(idx):
	if idx==0:
		return "char id"
	elif idx==1:
		return "Text "
	elif idx==2:
		return "variable name"
	elif idx==3:
		return "Default"
	
func _get_working_memory_size():
	return 1
func _step(inputs, outputs, start_mode, working_mem):
		#ADD IN LIST
	var ren = Engine.get_main_loop().root.get_node("Window")
	var obj=ren.values
	if obj.has("RenVS"):
		if not(self in obj["RenVS"]["value"]):
			obj["RenVS"]["value"].append(self)
		else:
			print("is in list")
			allow_back=false
	else:
		var arr=Array()
		arr.append(self)
		ren.define("RenVS",[self])
		
		
	
	var kwargs=[]
	#var ren = Engine.get_main_loop().root.get_node("Window")
	#ren.define(inputs[2])
	var s={"how":inputs[0],"what":inputs[1],"input_value":inputs[2],"value":inputs[3]}
	if start_mode==START_MODE_BEGIN_SEQUENCE or start_mode==START_MODE_CONTINUE_SEQUENCE:
		ren.input(s)
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
		print("push or next")
		if ren.get_meta("go_back"):
			print("push")
			#ren.statements.pop_back()
			#ren.statements.pop_back()
			return 0 | STEP_GO_BACK_BIT

		else:
			if allow_back:
				return 0 | STEP_PUSH_STACK_BIT
			else:
				return 0