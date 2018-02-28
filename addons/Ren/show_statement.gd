## This is Ren API ##
## version: 0.5.0 ##
## License MIT ##
## Show Node statement class ##

extends "statement.gd"
var _node

func _init(node):
	type = "show"
	kws = ["x", "y", "z", "at", "pos", "camera"]
	_node = node

func is_procent(x):
	return (typeof(x) == TYPE_REAL
			and x >= 0.0
			and x <= 1.0)

func enter(dbg = true):
	if dbg:
		print(debug(kws))

	var xnode = ren.values[_node].value
	
	var xcam = 0
	var ycam = 0
	var cam = null
	
	if "camera" in kwargs:
		cam = ren.values[kwargs.camera].value
		xcam = cam.postion.x
		ycam = cam.postion.y
	
	var x = 0

	if "x" in kwargs:
		x = kwargs.x
	
	elif xnode is Node2D:
		x = xnode.position.x
	
	elif xnode is Control:
		x = xnode.rect_position.x
	
	elif xnode is Spatial:
		x = xnode.translation.x

	elif "at" in kwargs:
		if "left" in kwargs.at:
			x = 0.0

		if "center" in kwargs.at:
			x = 0.5
		
		if "left" in kwargs.at:
			x = 1.0

	if is_procent(x) and x != 0:
		x = xcam + OS.window_size.x * x
		
		if xnode is Node2D:
			x -= xnode.get_viewport_rect().size.x/2
		
		elif xnode is Control:
			x -= xnode.rect_size.x/2

		elif xnode is VisualInstance and cam is Camera:
			x = cam.project_position(Vector2(x,0)) - xnode.get_aabb().size.x/2
	
	var y = 0

	if "y" in kwargs:
		y = kwargs.y

	elif xnode is Node2D:
		y = xnode.position.y
	
	elif xnode is Control:
		y = xnode.rect_position.y
	
	elif xnode is Spatial:
		y = xnode.translation.y

	elif "at" in kwargs:
		if "top" in kwargs.at:
			y = 0.0

		if "center" in kwargs.at:
			y = 0.5
		
		if "bottom" in kwargs.at:
			y = 1.0
	
	if is_procent(y) and y != 0:
		y = ycam + OS.window_size * y
	
		if xnode is Node2D:
			y -= xnode.get_viewport_rect().size.y/2
		
		elif xnode is Control:
			y -= xnode.rect_size.y/2
		
		elif xnode is VisualInstance and cam is Camera:
			y = cam.project_position(Vector2(0,y)) - xnode.get_aabb().size.y/2 
	
	var pos = Vector2(x, y)
	if "pos" in kwargs:
		pos = kwargs.pos

	var z = 0
	if "z" in kwargs:
		if xnode is Node2D:
			xnode.z = kwargs.z
		else:
			z = kwargs.z
	
	elif xnode is Spatial:
		z = xnode.translation.z
	
	if xnode is Control:
		xnode.rect_position = pos
	
	elif xnode is Node2D:
		xnode.position = pos
	
	elif xnode is Spatial:
		xnode.translation = Vector3(x, y, z)
		
	if !xnode.visible:
		xnode.show()
		
	.enter(false)
	on_exit()

