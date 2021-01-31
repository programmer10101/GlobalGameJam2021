extends Node2D
signal coord
signal buildMaze

func _ready():
	pass # Replace with function body.
	
func _init(x=5, y=10):
	emit_signal("buildMaze", Vector2(x,y))

func _on_TileMap_coordinates(arr):
	emit_signal("coord", arr)
	queue_free()
