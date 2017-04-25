## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##

extends Object

var ren_say
var choice_screen
var input_screen

var snum = 0 ## current statement number
var seen_statements = []
var statements = []
var can_roll = true
var important_types = ["say", "input", "menu"]

signal statement_changed

func next_statement():
    ## go to next statement
    use_statement(snum + 1)


func prev_statement():
    ## go to previous statement
    
    var prev = seen_statements.find(statements[snum])
    prev = seen_statements[prev - 1]
    prev = statements.find(prev)

    use_statement(prev)


func jump_to_statement(statement):
    var id = statements.find(statement)
    use_statement(id)


func _input(event):

    if can_roll and snum > 0:
        if event.is_action_pressed("ren_rollforward"):
            next_statement()
        
        elif event.is_action_pressed("ren_rollback"):
            prev_statement()
        

func use_statement(num):
    ## go to statement with given number
    if num < statements.size() - 1 and num >= 0:
        var s = statements[num]
        
        if s.type == "say":
            ren_say.say(s)
        
        elif s.type == "input":
            input_screen.use(s)
        
        elif s.type == "menu":
             choice_screen..menu(s)

        elif s.type == "menu_func":
             choice_screen.menu_func(s)
        
        elif s.type == "jump_to_statement":
            jump_to_statement(s)
        
        elif s.type == "g":
            callv(s.fun, s.args)
            
        if num + 1 < statements.size():
            if not is_statement_id_important(num + 1):
                use_statement(num + 1)
        
        if is_statement_important(s):
            mark_seen(s)
        
        snum = num
        
        emit_signal("statement_changed")


func mark_seen(statement):
    ## add statement to save
    ## and make statement skipable
    if statement in seen_statements:
        pass

    else:
        seen_statements.append(statement)


func was_seen_id(statement_id):
    ## check if player seen statement with this id already
    return statements[statement_id] in seen_statements


func is_statement_id_important(statement_id):
    ## return true if statement with this id is say, input or menu type
    return is_statement_important(statements[statement_id])


func is_statement_important(statement):
    ## return true if statement is say, input or menu type
    var important = false
      
    if statement.type in important_types:
        important = true
    
    return important


func was_seen(statement):
    ## check if player seen this statement already
    return statement in seen_statements


func godot_line(fun, args = []):
    ## append g statement
    ## use it to execute godot func in rengd
    var s = {"type":"g",
            "fun":fun
            }
    
    return s