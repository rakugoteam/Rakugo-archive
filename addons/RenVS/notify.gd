tool
extends VisualScriptCustomNode

export var allow_back=true

func _get_caption():
	return "Notify"
func _get_input_value_port_count():
	return 2
func _get_input_value_port_name( idx ):
	if idx==0:
		return "Notify text"
	elif idx==1:
		return "Time length"
func _get_input_value_port_type( idx ):
	if idx==0 :
		return TYPE_STRING
	elif idx==1:
		return TYPE_INT

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
	var ren = Engine.get_main_loop().root.get_node("Window")
	if self.get_instance_id() in ren.vnl:
		print(inputs[1],"already there")
		allow_back=false
	else:
		print(inputs[1],"added")
		ren.vnl.append(self.get_instance_id())

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
		
	if ren.vis_loading:
		if start_mode==START_MODE_CONTINUE_SEQUENCE:
			return 0 | STEP_GO_BACK_BIT
		else:
			if allow_back:
				return 0 | STEP_PUSH_STACK_BIT
			else:
				return 0

	#print("test get id",get_visual_script().get_function_node_id("_ready"))

	var s=[inputs[0],inputs[1]]
	var kwargs=[]
	#var ren = Engine.get_main_loop().root.get_node("Window")
	if !ren.has_meta("usingvis"):
		ren.set_meta("usingvis",true)
		
	
	if start_mode==START_MODE_CONTINUE_SEQUENCE:
		print("pushed back")
		ren.notifiy(s[0],s[1])
		if !ren.get_meta("playing"):
			ren.start()
		else:
			ren.statements[ren.current_statement_id].enter()
		var n= VisualScriptFunctionState.new()
		#n.connect_to_signal(Engine.get_main_loop(),"idle_frame",[])
		working_mem[0]=n
		print(n)
		return 0 | STEP_GO_BACK_BIT

	if start_mode==START_MODE_BEGIN_SEQUENCE :
		ren.notifiy(s[0],s[1])
		if !ren.get_meta("playing"):
			ren.start()
		else:
			ren.statements[ren.current_statement_id].enter()
		var n= VisualScriptFunctionState.new()
		#n.connect_to_signal(Engine.get_main_loop(),"idle_frame",[])
		working_mem[0]=n
		print(n)
		if allow_back:
			return 0 | STEP_PUSH_STACK_BIT
		else:
			return 0

