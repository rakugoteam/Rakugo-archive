extends Dialogue



func some_dialog():
	start_event("some_dialog")
	
	print(event_stack)
	print("starting the event")
	for i in range(10):
		print("Say #%s" % [str(i)])
		say({"what": "Say #%s" % [str(i)]})
		step()
	print("ending the event")
	
	end_event()
