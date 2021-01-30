extends TileMap
signal coordinates

func _ready():
	pass
	
func reset():
	for x in range(3, 23):
		for y in range(3, 25):
			set_cell(x, y, 1)
			
func submit():
	emit_signal("coordinates", get_used_cells_by_id(1))

func _process(delta):
	var loc = get_mouse_loc()
	var cell = get_cell(loc.x, loc.y)
	if Input.is_mouse_button_pressed(1):
		match cell:
			-1: pass
			0: pass
			1: set_cell(loc.x, loc.y, -1)
			2: reset()
			3: submit()
			4: pass
			
		print(cell)
	if Input.is_mouse_button_pressed(2):
		if (cell == -1):
			set_cell(loc.x, loc.y, 1)
			
func get_mouse_loc():
	var pos = get_viewport().get_mouse_position()
	return world_to_map(pos)

func _on_Label_go():
	submit()

func _on_Reset_pressed():
	reset()

func _on_Submit_pressed():
	submit()
