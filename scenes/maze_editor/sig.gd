extends Node2D
signal coord

func _ready():
	pass # Replace with function body.

func _on_TileMap_coordinates(arr):
	emit_signal("coord", arr)
	queue_free()
