extends Spatial
const Character = preload("res://scenes/character/Character.tscn")

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

func init(mazeCells, start, ext):
    setMinMaxes(mazeCells)
    print(minX)
    print(minY)
    print(maxX)
    print(maxY)
    print(start)
    var mazeDimensions = findMazeDimensions()
    adjustForOffsets(mazeCells, mazeDimensions)
    var startPos = adjustForOffset(start, mazeDimensions)
    var charPos = Vector3(startPos.x * cube_size, 2.5, (startPos.y) * cube_size)
    var startWallPos = Vector2(startPos.x, startPos.y - 1)
    $WorldEnvironment.init(mazeCells + [startWallPos], cube_size)
    $WorldEnvironment/CSGBox.width = mazeDimensions.x + 1
    $WorldEnvironment/CSGBox.depth = mazeDimensions.y + 1
    generateCharacter(charPos)

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
    
func generateCharacter(loc):
    var character = Character.instance()
    character.translation = loc
    add_child(character)
    
    
func findMazeDimensions():
    return Vector2((maxX - minX), (maxY - minY))
    
func adjustForOffsets(mazeCells, mazeDimensions):
    for i in range(mazeCells.size()):
        mazeCells[i] = adjustForOffset(mazeCells[i], mazeDimensions)
        
func adjustForOffset(mazeCell, mazeDimensions):
    mazeCell.x -= mazeDimensions.x / 2.0 + minX
    mazeCell.y -= mazeDimensions.y /2.0 + minY
    return mazeCell

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
