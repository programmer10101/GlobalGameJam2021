extends Control


signal start_sandbox
signal start_multiplayer
signal quit_game


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func _on_StartSandbox_pressed():
    emit_signal("start_sandbox")


func _on_StartMultiplayer_pressed():
    emit_signal("start_multiplayer")
    

func _on_QuitGame_pressed():
    emit_signal("quit_game")



