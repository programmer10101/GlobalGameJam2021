extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# onready var character = owner.get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    
func _input(event):
    if event is InputEventMouseMotion:
        self.rotate_x(-event.relative.y * 0.01)
        self.rotation_degrees.x = clamp(self.rotation_degrees.x, -80, 80)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
