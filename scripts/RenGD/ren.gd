## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.7 ##
## License MIT ##


extends Node

var vbc = "VBoxContainer"

## paths to nodes to use with special kinds of charcters
var adv_path = "Adv/" + vbc
var cen_path = "Center/" + vbc
var fs_path = "FullScreen" + vbc

onready var input_screen = get_node(adv_path + "/Input")
onready var say_screen = get_node(adv_path)
onready var nvl_scroll = get_node("Nvl")
onready var nvl_screen = get_node("Nvl/" + vbc)
onready var label_manager = get_node("LabelManager")
onready var choice_screen = get_node("Choice")

onready var say_scene = preload("res://scenes/gui/Say.tscn")

var snum = 0 ## current statement number
var seen_statements = []
var statements = []
var keywords = { "version":{"type":"text", "value":"0.7"} }
var can_roll = true

var important_types = ["say", "input", "menu"]

signal statement_changed

const REN_DEF = preload("ren_def.gd")
var ren_def

const REN_TXT = preload("ren_text.gd")
var ren_txt

func _ready():
    
    ren_def = REN_DEF.new()
    ren_txt = REN_TXT.new()

    ## code borrow from:
    ## http://docs.godotengine.org/en/stable/tutorials/step_by_step/singletons_autoload.html
    var root = get_tree().get_root()
    label_manager.current_scene = root.get_child( root.get_child_count() -1 )
    
    set_process_input(true)

func start_ren():
    ## This must be at end of code using ren api
	## this start ren "magic" ;)
    use_statement(0)


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


func print_statment(message):
    ## to debug ren stuff in right order
    return {"type": "print", "arg": message}


func append_print_statment(message):
    ## to debug ren stuff in right order
    var s = print_statment(message)
    statements.append(s)


func use_print(s):
    print(s.arg)

func use_statement(num):
    ## go to statement with given number
    if num < statements.size() - 1 and num >= 0:
        var s = statements[num]
        
        if s.type == "say":
            say(s)
        
        elif s.type == "input":
            input(s)
        
        elif s.type == "menu":
            menu(s)
        
        elif s.type == "print":
            use_print(s)
        
        # elif s.type == "jump_to_statement":
        #     jump_to_statement(s)
        
        # elif s.type == "g":
        #     callv(s.fun, s.args)
            
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


## code borrow from:
## http://docs.godotengine.org/en/stable/tutorials/step_by_step/singletons_autoload.html
func goto_scene(path):

    ## This function will usually be called from a signal callback,
    ## or some other function from the running scene.
    ## Deleting the current scene at this point might be
    ## a bad idea, because it may be inside of a callback or function of it.
    ## The worst case will be a crash or unexpected behavior.

    ## The way around this is deferring the load to a later time, when
    ## it is ensured that no code from the current scene is running:

    call_deferred("_deferred_goto_scene", path)


## code borrow from:
## http://docs.godotengine.org/en/stable/tutorials/step_by_step/singletons_autoload.html
func _deferred_goto_scene(path):

    ## Immediately free the current scene,
    ## there is no risk here.
    label_manager.current_scene.free()

    ## Load new scene
    var s = load(path)

    ## Instance the new scene
    label_manager.current_scene = s.instance()

    ## Add it to the active scene, as child of root
    get_tree().get_root().add_child(label_manager.current_scene)

    ## optional, to make it compatible with the SceneTree.change_scene() API
    get_tree().set_current_scene( label_manager.current_scene )


func define(key_name, key_value = null):
    ## add global var that ren will see
    ren_def.define(keywords, key_name, key_value)
    

func Character(name="", color ="", what_prefix="", what_suffix="", kind="adv"):
    ## return new Character
    var ch = ren_def.Character(name, color, what_prefix, what_suffix, kind)
    return ch


func text_passer(text = ""):
    ## passer for renpy markup format
    ## its retrun bbcode
    return ren_txt.text_passer(keywords, text)


func label(label_name, scene_path, node_path = null, func_name = null):
    ## this declare new label
    ## that make ren see label and can jump to it
    label_manager.label(label_name, scene_path, node_path, func_name)


func jump(label_name, args = []):
    ## go to other declared label
    label_manager.jump(label_name, args)


func say_statement(how, what):
    ## return input statement
    return say_screen.statement(how, what)


func append_say(how, what):
    ## append say statement 
    var s = say_statement(how, what)
    statements.append(s)


func say(statement):
    ## "run" say statement
    var how = statement.args.how

    # if how.kind == "adv":
    say_screen = get_node(adv_path)

    if how in keywords:
        if keywords[how].type == "Character":
            var kind = keywords[how].value.kind
            
            if kind == "center":
                say_screen.hide()
                get_node(fs_path).hide()
                say_screen = get_node(cen_path)
            
            elif kind == "fullscreen":
                say_screen.hide()
                get_node(cen_path).hide()
                say_screen = get_node(fs_path)
            
            elif kind == "nvl":
                say_screen.hide()
                get_node(fs_path).hide()
                get_node(cen_path).hide()
                say_screen = say_scene.instance()
                nvl_screen.add_child(say_screen)
                var y = say_screen.get_pos().y
                nvl_scroll.set_v_scroll(y)
                nvl_scroll.show()
    
            if kind != "nvl":
                var ipath = str(say_screen.get_path()) + "/Input"
                input_screen = get_node(ipath)

    say_screen.use(statement)


func input_statement(ivar, what, temp = ""):
    ## return input statement
    return input_screen.statement(ivar, what, temp)


func append_input(ivar, what, temp = ""):
    ## append input statement
    var s = input_statement(ivar, what, temp)
    statements.append(s)


func array_slice(array, from = 0, to = 0):
 	if from > to or from < 0 or to > array.size():
 		return array
 	
 	var _array = array
 
 	for i in range(0, from):
 		_array.remove(i)
     
 	_array.resize(to - from)
 
 	return _array


func input(statement):
   ## "run" input statement
   input_screen.use(statement)


func before_menu():
    ## must be on begin of menu custom func
    choice_screen.before_menu()


func after_menu():
	## must be on end of menu custom func
    choice_screen.after_menu()


func menu_statement(choices, title = "", node = null, func_name = ""):
	## return custom menu statement
	## made to use menu statement easy to use with gdscript
    return choice_screen.statement(choices, title, node, func_name)


func append_menu(choices, title = "", node = null, func_name = ""):
    ## append menu_func statement
    var s = menu_statement(choices, title, node, func_name)
    statements.append(s)


func menu(statement):
    ## "run" menu statement
    choice_screen.use(statement)

# don't work  for now :(

# func godot_line(fun, args = []):
#     ## append g statement
#     ## use it to execute godot func in rengd
#     var s = {"type":"g",
#             "fun":fun,
#             "args":args
#             }
    
#     return s


# func append_godot_line(fun, args = []):
#     ## return g statement
#     ## use it to execute godot func in rengd
#     var s = append_godot_line(fun, args)
#     statements.append(s)



