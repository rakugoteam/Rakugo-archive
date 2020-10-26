extends Dialogue

var path_choice = ''

func some_dialog():
	start_event("some_dialog")


	say(null, "Show 'rect {color=red}red{/color}', step #%d" % get_event_step(), {"typing":true})
	show("rect red")
	step()
	
	say(null, "Show 'rect {color=blue}blue{/color}', step #%d" % get_event_step(), {"typing":true})
	show("rect blue")
	notify("Some notification that is really important to show")
	step()
	
	say(null, "Hide 'rect red', step #%d" % get_event_step(), {"typing":true})
	hide("rect red")
	step()
	
	say(null, "Little test of the choice menu", {"typing":true})
	var choice = menu([["Choice 1", 1, {}], ["Choice 2", 2, {'visible':true}],["Choice 3", 3, {'visible':false}]])
	step()
	
	say(null, "You chose '%s' (not saved)  image tag test :{img=res://addons/Rakugo/emojis/16x16/1f1e6.tres}" % str(choice))
	step()
	
	say(null, "Show 'rect'(inexistant), step #%d  emoji tag test {:1f1e6:}" % get_event_step())
	show("rect")
	step()
	
	say(null, "Hide 'rect', step #%d" % get_event_step())
	hide("rect")
	step()
	
	say(null, "Select a path")
	show("rect red")
	show("pathchoice")
	step()
	
	if cond(path_choice == 'green'):
		say(null, "Green path chosen, yeah fuck blue")
		show("rect green")
		hide("pathchoice")
		step()
		
		say(null, "I confirm {color=[path_color]}[path_color]{/color} chosen")
		step()
		
		say(null, "Step #%d Green" % get_event_step())
		step()
		say(null, "Step #%d Green" % get_event_step())
		step()
		say(null, "Step #%d Green" % get_event_step())
		step()
	elif cond(path_choice == 'blue'):
		say(null, "Blue FTW, Green is for tards, amiright")
		show("rect blue")
		hide("pathchoice")
		step()
		
		say(null, "I confirm {color=[path_color]}[path_color]{/color} chosen")
		step()
		
		say(null, "Step #%d Blue" % get_event_step())
		step()
		say(null, "Step #%d Blue" % get_event_step())
		step()
		say(null, "Step #%d Blue" % get_event_step())
		step()
		say(null, "Step #%d Blue" % get_event_step())
		step()
	else:
		say(null, "Haha you did the right thing not picking of those inferior colors, ")
		hide("pathchoice")
		step()
		
		say(null, "Step #%d RED" % get_event_step())
		step()
		say(null, "Step #%d RED" % get_event_step())
		step()
		say(null, "Step #%d RED" % get_event_step())
		step()
		say(null, "Step #%d RED" % get_event_step())
		step()
		say(null, "Step #%d RED" % get_event_step())
		step()
		
	say(null, "Step #%d" % get_event_step())
	step()
	say(null, "Step #%d" % get_event_step())
	step()
	
	end_event()


func _on_green_path_chosen():
	self.path_choice = "green"
	Rakugo.store.path_color = "green"
	Rakugo.story_step()


func _on_blue_path_chosen():
	self.path_choice = "blue"
	Rakugo.store.path_color = "blue"
	Rakugo.story_step()
