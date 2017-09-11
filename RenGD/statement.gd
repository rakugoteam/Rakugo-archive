## This is Ren'GD API ##

## version: 0.1.0 ##
## License MIT ##
## Base class for statement ##

extends Node

var type = "base"
var id = 0
var _statements = []
var _kwargs = {}

# move to ren.G6DOF_JOINT_ANGULAR_DAMPING
# signal use_statemnet(type = "", _kwargs = {})

func _init(kwargs, index, statemnets):
    id = index
    _statements = statements
    _kwargs = kwargs


func use(use_input = true):
    emit_signal("statement", type, _kwargs)
    set_process_input(use_input)


func next():
    set_process_input(false)
    var next_sid = find_next()
    if next_sid > -1:
        _statements[next_sid].use()


func _input(event):
    if event.is_action_released("ren_rollforward"):
        next()


func find_next(types = []):
    var next_sid = -1
    
    if id + 1 <= _statements.size():
        if stype == []:
            next_sid = id + 1
        
        else:
            for i in range(id, _statements.size()):
                if _statements[i].type in types:
                    next_sid = _statements[i].id
                    break
    
    return next_sid

func debug():
    print(type, kwargs)