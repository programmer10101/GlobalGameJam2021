extends TileMap
signal coordinates

func _ready():
    pass
    
func reset():
	for x in range(3, 23):
		for y in range(3, 25):
			set_cell(x, y, 5)
			
func submit():
	emit_signal("coordinates", get_used_cells_by_id(5) + get_used_cells_by_id(6))

func _process(delta):
	if Input.is_mouse_button_pressed(1):
		var pos = get_viewport().get_mouse_position()
		var loc = world_to_map(pos)
		var cell = get_cell(loc.x, loc.y)
		match cell:
			5: set_cell(loc.x, loc.y, -1)	
		print(cell)
    if Input.is_mouse_button_pressed(2):
        if (cell == 7):
            set_cell(loc.x, loc.y, 5)

func get_mouse_loc():
    var pos = get_viewport().get_mouse_position()
    return world_to_map(pos)

func _on_Label_go():
    submit()

func _on_Reset_pressed():
    reset()

func _on_Submit_pressed():
    submit()
