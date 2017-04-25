## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##

extends Object 

var adv_path
var cen_path
var fs_path

var say_screen
var nvl_scroll
var nvl_screen
var input_screen
var say_scene

func say(statement):
    ## "run" say statement
    var how = slef.statement.args.how

    # if how.kind == "adv":
    say_screen = get_node(adv_path)

    if how in self.keywords:
        if self.keywords[how].type == "Character":
            var kind = self.keywords[how].value.kind
            
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