extends Dialogue

var path_choice = ''

func some_dialog():
	start_event("some_dialog")


	say({"what": "Show 'rect red', step #%d" % get_event_step()})
	show("rect red")
	step()
	
	say({"what": "Show 'rect blue', step #%d" % get_event_step()})
	show("rect blue")
	step()
	
	say({"what": "Hide 'rect red', step #%d" % get_event_step()})
	hide("rect red")
	step()
	
	say({"what": "Show 'rect'(inexistant), step #%d" % get_event_step()})
	show("rect")
	step()
	
	say({"what": "Hide 'rect', step #%d" % get_event_step()})
	hide("rect")
	step()
	
	say({"what": "Select a path"})
	show("rect red")
	show("pathchoice")
	step()
	
	if cond(path_choice == 'green'):
		say({"what": "Green path chosen, yeah fuck blue"})
		show("rect green")
		hide("pathchoice")
		step()
		
		say({"what": "Step #%d Green" % get_event_step()})
		step()
		say({"what": "Step #%d Green" % get_event_step()})
		step()
		say({"what": "Step #%d Green" % get_event_step()})
		step()
	elif cond(path_choice == 'blue'):
		say({"what": "Blue FTW, Green is for tards, amiright"})
		show("rect blue")
		hide("pathchoice")
		step()
		
		say({"what": "Step #%d Blue" % get_event_step()})
		step()
		say({"what": "Step #%d Blue" % get_event_step()})
		step()
		say({"what": "Step #%d Blue" % get_event_step()})
		step()
		say({"what": "Step #%d Blue" % get_event_step()})
		step()
	else:
		say({"what": "Haha you did the right thing not picking of those inferior colors, "})
		hide("pathchoice")
		step()
		
		say({"what": "Step #%d RED" % get_event_step()})
		step()
		say({"what": "Step #%d RED" % get_event_step()})
		step()
		say({"what": "Step #%d RED" % get_event_step()})
		step()
		say({"what": "Step #%d RED" % get_event_step()})
		step()
		say({"what": "Step #%d RED" % get_event_step()})
		step()
		
	say({"what": "Step #%d" % get_event_step()})
	step()
	say({"what": "Step #%d" % get_event_step()})
	step()
	
	end_event()


func _on_green_path_chosen():
	self.path_choice = "green"
	Rakugo.story_step()


func _on_blue_path_chosen():
	self.path_choice = "blue"
	Rakugo.story_step()
