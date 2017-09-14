## This is Ren'GD API ##

## version: 0.1.0 ##
## License MIT ##
## Base class for statement ##

extends Node

var type = "base"
var id = 0
var _kwargs = {}
var _ren

# move to ren.G6DOF_JOINT_ANGULAR_DAMPING
# signal use_statemnet(type = "", _kwargs = {})

func _init(kwargs, index, ren):
    id = index
    _kwargs = kwargs
    _ren = ren


func use():
    debug()
    emit_signal("statement", type, _kwargs)

    
func next(types = []):
    var next_sid = find_next(types)
    if next_sid > -1:
        ren.statements[next_sid].use()


func find_next(types = []):
    var next_sid = -1
    
    if id + 1 <= ren.statements.size():
        if stype == []:
            next_sid = id + 1
        
        else:
            for i in range(id, ren.statements.size()):
                if ren.statements[i].type in types:
                    next_sid = ren.statements[i].id
                    break
    
    return next_sid


func debug(kw = []):
    dbg = type + "("
    
    for k in _kwargs:
        if k in kw:
            dbg += k + " = " + _kwargs[k] +", "
    
    dbg += ")"
    print(dbg)