extends TileMap
signal coordinates

func _ready():
    pass

func _process(delta):
<<<<<<< HEAD
    if Input.is_mouse_button_pressed(1):
        var pos = get_viewport().get_mouse_position()
        var loc = world_to_map(pos)
        var cell = get_cell(loc.x, loc.y)
        match cell:
            -1: pass
            3: pass
            1: set_cell(loc.x, loc.y, -1)
            0: pass # submit get_used_cells_by_id(4)
            2: for x in range(3, 23):
                for y in range(3, 25):
                    set_cell(x, y, 1)
        print(cell)
=======
	if Input.is_mouse_button_pressed(1):
		var pos = get_viewport().get_mouse_position()
		var loc = world_to_map(pos)
		var cell = get_cell(loc.x, loc.y)
		match cell:
			-1: pass
			3: pass
			1: set_cell(loc.x, loc.y, -1)
			0: emit_signal("coordinates", get_used_cells_by_id(1))
			2: for x in range(3, 23):
				for y in range(3, 25):
					set_cell(x, y, 1)
		print(cell)
>>>>>>> origin/master
