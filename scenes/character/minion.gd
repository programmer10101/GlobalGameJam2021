extends KinematicBody
class_name Minion
signal done

var GRAVITY = -24.8
var MAX_SPEED = 6
var JUMP_FORCE = 9
var ACCEL = 6
var DECEL = 6

var dir : Vector3
var vel : Vector3

var camera : Camera

enum Command { FORWARD, BACKWARD, LEFT, RIGHT, JUMP, SPRINT, PRIMARY, SECONDARY }
var cmd = [false, false, false, false, false, false, false, false]

func _ready():
    camera = $controller/Camera
    var _state_entered = connect("state_entered", self, "_on_state_entered")
    var _state_exited = connect("state_exited", self, "_on_state_exited")

func _physics_process(delta):
    if camera != null:
        # Direction is controlled by the commands to the character
        # Camera's Z basis is a local forward backward Z axis.
        # X is for right and left movement.
        dir = (int(cmd[Command.FORWARD]) - int(cmd[Command.BACKWARD])) * camera.transform.basis.z * -1
        dir += (int(cmd[Command.RIGHT]) - int(cmd[Command.LEFT])) * camera.transform.basis.x
    # Normalize direction so the diagonal movement doesn't exceed 1
    dir = dir.normalized()
    # Ground movement
    dir.y = 0
    vel.y += delta * GRAVITY
    var hvel = vel
    hvel.y = 0
    var target = dir
    target *= MAX_SPEED
    var accel
    if dir.dot(hvel) > 0:
        accel = ACCEL
    else:
        accel = DECEL
    hvel = hvel.linear_interpolate(target, accel * delta)
    vel.x = hvel.x
    vel.z = hvel.z
    vel.y = move_and_slide(vel, Vector3.UP, true, 4, 0.8, false).y
    if cmd[4]:
        vel.y = JUMP_FORCE
    if translation.distance_to(get_parent().endPos) < 2.2:
        $Label.show()
        emit_signal("done", "I won this game")
    
    # Update the position and rotation over network
    # If this character is controlled by the actual player - send it's position and rotation
    #if $controller.has_method("is_player"):
        # RPC unreliable is faster but doesn't verify whether data has arrived or is intact
        #rpc_unreliable("network_update", translation, rotation, $shape_head.rotation)

# To update data both on a server and clients "sync" is used
sync func network_update(new_translation, new_rotation, head_rotation):
    translation = new_translation
    rotation = new_rotation
    $shape_head.rotation = head_rotation
