## This is Ren API ##

## version: 0.2.0 ##
## License MIT ##
## Base class for statement ##

from godot import exposed, export
from godot.bindings import Node

@exposed
class Statement(Node):
    # Maybe it should be just Object?

    type = "base"
    id = 0
    kwargs = {}
    statements = []

    def __init__(self, type = "base", id = "0", statements = [], **kwargs):
        self.type = type
        self.id = id
        self.kwargs = kwargs
    
    def debug(kw = []):
        dbg = type + "("
    
        for k in self.kwargs:
            if k in kw:
                dbg += k + " = " + self.kwargs[k] +", "
        
        dbg += ")"
        print(dbg)
    
    def use():
        self.debug()
        self.emit_signal("statement", self.type, self.kwargs)
    
    def next(types = []):
        next_sid = find_next(types)
        if next_sid > -1:
            self.statements[next_sid].use()

    def find_next(types = []):
        next_sid = -1
        
        if id + 1 <= self.statements.size():
            if stype == []:
                next_sid = id + 1
            
            else:
                for i in range(id, self.statements.size()):
                    if self.statements[i].type in types:
                        next_sid = self.statements[i].id
                        break
        
        return next_sid
    

