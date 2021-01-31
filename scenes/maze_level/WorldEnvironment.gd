extends WorldEnvironment
const Wall = preload("res://scenes/wall/Wall.tscn")

var cube_size
var collisionNode

func init(wallLocs, size):
    cube_size = size
    cube_size = 1
    generate_cubes(wallLocs)

func generate_cubes(wallLocs):
    for wallLoc in wallLocs:
        generate_cube(wallLoc)

func generate_cube(loc):
    var pos = Vector3(loc.x * cube_size, 0, loc.y * cube_size)
    var wall = Wall.instance()
    wall.translation = pos
    add_child(wall)
