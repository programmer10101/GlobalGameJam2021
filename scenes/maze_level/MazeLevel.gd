extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var minX
var maxX
var minY
var maxY
var cube_size = 1

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
    
func init(mazeCells):
    setMinMaxes(mazeCells)
    var mazeDimensions = findMazeDimensions()
    adjustForOffset(mazeCells, mazeDimensions)
    $WorldEnvironment.init(mazeCells, cube_size)
    $WorldEnvironment/CSGBox.width = mazeDimensions.x + 1
    $WorldEnvironment/CSGBox.depth = mazeDimensions.y + 1

func setMinMaxes(mazeCells):
    minX = mazeCells[0].x
    maxX = mazeCells[0].x
    minY = mazeCells[0].y
    maxY = mazeCells[0].y
    for i in mazeCells:
        minX = min(i.x, minX)
        minY = min(i.y, minY)
        maxX = max(i.x, maxX)
        maxY = max(i.y, maxY)
    
func findMazeDimensions():
    return Vector2((maxX - minX), (maxY - minY))
    
func adjustForOffset(mazeCells, mazeDimensions):
    for i in range(mazeCells.size()):
        mazeCells[i].x -= mazeDimensions.x / 2.0 + minX
        mazeCells[i].y -= mazeDimensions.y /2.0 + minY

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
