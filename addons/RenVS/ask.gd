tool
extends VisualScriptCustomNode

export var choices = 1 setget set_choices
export var allow_back = true
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
	if self.get_instance_id() in ren.vnl:
		print(inputs[1],"already there")
		allow_back=false
	else:
		print(inputs[1],"added")
		ren.vnl.append(self.get_instance_id())
	#LODING
	if ren.vis_loading:
		if ren.history_vis.size()>ren.load_counter:
			var m=ren.menu({"how":inputs[0],"what":inputs[1]})
			if ren.history_vis[ren.load_counter]==-1:
				ren.load_counter+=1
				return 0 | STEP_GO_BACK_BIT
			else:
				ren.load_counter+=1
				if not(get_instance_id() in ren.vnl):
					print(self.get_instance_id(),"vnl is : { ",ren.vnl,"}")
					return ren.history_vis[ren.load_counter-1] | STEP_PUSH_STACK_BIT
				else:
					return ren.history_vis[ren.load_counter-1]
	

	var kwargs=[]
	
	if start_mode==START_MODE_CONTINUE_SEQUENCE and ren.get_meta("go_back")==false:
		return 0 
	if start_mode==START_MODE_BEGIN_SEQUENCE or start_mode==START_MODE_CONTINUE_SEQUENCE:
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
		#print("got choice ",ren.get_meta("last_choice"))
		print("push or next")
		if ren.get_meta("quitcurrent")==true:
			return 0 | STEP_NO_ADVANCE_BIT
		if ren.get_meta("go_back"):
			print("push bback")
			#ren.statements.pop_back()
			#ren.statements.pop_back()
			ren.history_vis.append(-1)
			return 0 | STEP_GO_BACK_BIT
		else:
			if allow_back:
				ren.history_vis.append(ren.get_meta("last_choice"))
				return ren.get_meta("last_choice") | STEP_PUSH_STACK_BIT
			else:
				ren.history_vis.append(ren.get_meta("last_choice"))
				return ren.get_meta("last_choice")