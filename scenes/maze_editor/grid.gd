extends TileMap
signal coordinates
var currentTile
var initialLocation
var mazeSize
var entrance
var exit
var path =[]
var pressed = false
var tile = 7
onready var nav_2d: Navigation2D = $Navigation2D

func _unhandled_input(event):
	if not event.is_action_pressed("click"):
		return
	_update_navigation_path(entrance, exit)

func _update_navigation_path(start_position, end_position):
	path = get_parent().get_simple_path(start_position, end_position)
	var bt = get_node("Control/VBoxContainer/Submit")
	if(len(path) > 0): bt.disabled = false
	else: bt.disabled = true
	path.remove(0)

func _ready():
	initialLocation = get_node(".").get_position()
	mazeSize = Vector2(16, 16)
	currentTile = Vector2(ceil(mazeSize.x/2)+5, ceil(mazeSize.y/2)+5)
	reset()

func _input(event):
	if event is InputEventMouse:
		var pos = event.position
		var loc = world_to_map(pos-initialLocation)
		if event is InputEventMouseMotion:
			if pressed and insideMaze(loc): set_cellv(loc, tile)
			else:
				if insideMaze(loc):
					var lastCell = get_cell(currentTile.x, currentTile.y)
					var cell = get_cell(loc.x, loc.y)
					if(currentTile != loc and lastCell == -1): 
						set_cellv(currentTile, 5)
					elif(cell == 5 ): 
						set_cellv(loc, -1)
					currentTile = loc
				else: 
					var lastCell = get_cell(currentTile.x, currentTile.y)
					if lastCell == -1: set_cellv(currentTile, 5)
		#var pos = get_viewport().get_mouse_position()
		var cell = get_cell(loc.x, loc.y)
		if event is InputEventMouseButton: #Input.is_mouse_button_pressed(1):
			pressed = event.is_pressed()
			if event.button_index == BUTTON_LEFT:
				tile = 7
				if(insideMaze(loc) and cell == -1):
					set_cell(loc.x, loc.y, 7)
				_update_navigation_path(map_to_world(entrance)+initialLocation, map_to_world(exit)+initialLocation)
			else:
				tile = 5
				if (cell == 7):
					set_cell(loc.x, loc.y, 5)
				_update_navigation_path(map_to_world(entrance)+initialLocation, map_to_world(exit)+initialLocation)

func insideMaze(loc):
	if (loc.x > 5 and loc.x < mazeSize.x+5 and loc.y > 5 and loc.y < mazeSize.y+5):
		return true

func reset():
	for x in range(5, mazeSize.x+6):
		for y in range(5, mazeSize.y+6):
			if x == 5 : set_cell(x, y, 6)
			elif x == mazeSize.x+5: set_cell(x, y, 6)
			elif y == 5: set_cell(x, y, 6)
			elif y == mazeSize.y+5: set_cell(x, y, 6)
			else: set_cell(x, y, 5)
	var mid = mazeSize.x / 2
	entrance = Vector2(floor(mid)+5, 5)
	exit = Vector2(ceil(mid)+5, mazeSize.y+5)
	set_cellv(entrance, 7)
	set_cellv(exit, 7)
		
func submit():
	emit_signal(
		"coordinates", 
		get_used_cells_by_id(5) + get_used_cells_by_id(6),
		entrance, exit)

func get_mouse_loc():
	var pos = get_viewport().get_mouse_position()
	return world_to_map(pos)

func _on_Label_go():
	submit()

func _on_Reset_pressed():
	reset()

func _on_Submit_pressed():
	submit()

func _on_MazeEditor_buildMaze(vec):
	mazeSize = vec
	currentTile = Vector2(vec.x-10, vec.y-10)
	reset()
