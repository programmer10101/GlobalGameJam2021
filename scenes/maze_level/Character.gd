extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var inputVector = Vector2(0,0)
var MAXSPEED = .25

# Called when the node enters the scene tree for the first time.
func _ready():
    pass

func _input(event):
    if event is InputEventMouseMotion:
        self.rotate_y(-event.relative.x * 0.01)
        
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    self.apply_central_impulse(Vector3(inputVector.x, 0, inputVector.y).rotated(Vector3(0,1,0), self.rotation.y ) * 10 * delta)
    if abs(self.linear_velocity.length()) > MAXSPEED:
        self.angular_velocity = self.angular_velocity.normalized() * MAXSPEED

func _physics_process(_delta):
    var input = Vector2(0,0)
    if Input.is_action_pressed("forward"):
        input.y -=1
    if Input.is_action_pressed("backward"):
        input.y +=1
    if Input.is_action_pressed("left"):
        input.x -=1
    if Input.is_action_pressed("right"):
        input.x +=1
    inputVector = input.normalized()
