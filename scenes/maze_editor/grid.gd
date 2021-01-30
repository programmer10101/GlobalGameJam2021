extends TileMap
signal coordinates
var currentTile = Vector2(13, 3)

func _ready():
    pass

func _input(event):
    if event is InputEventMouseMotion:
        var pos = event.position
        var loc = world_to_map(pos)
        if insideMaze(loc):
            var lastCell = get_cell(currentTile.x, currentTile.y)
            var cell = get_cell(loc.x, loc.y)
            if(currentTile != loc ): print(lastCell)
            if(currentTile != loc and lastCell == -1): 
                set_cellv(currentTile, 5)
            if(cell == 5 ): 
                set_cellv(loc, -1)
            currentTile = loc
        else:
            set_cellv(currentTile, 5)

func insideMaze(loc):
    if (loc.x > 2 and loc.x < 23 and loc.y > 2 and loc.y < 25):
        return true

func reset():
    for x in range(3, 23):
        for y in range(3, 25):
            set_cell(x, y, 5)
            
func submit():
    emit_signal("coordinates", get_used_cells_by_id(5) + get_used_cells_by_id(6))

func _process(delta):
    var pos = get_viewport().get_mouse_position()
    var loc = world_to_map(pos)
    var cell = get_cell(loc.x, loc.y)
    if Input.is_mouse_button_pressed(1):
        if(insideMaze(loc) and cell == -1):
            set_cell(loc.x, loc.y, 7)
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
