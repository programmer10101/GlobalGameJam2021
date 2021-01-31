extends Control

signal join_game
signal host_game
signal return_to_main_menu


onready var IpAddress = get_node("MarginContainer/VBoxContainer/HBoxContainer2/JoinIpAddress")
onready var IpChoices = get_node("MarginContainer/VBoxContainer/HBoxContainer/IpChoices")
onready var GameIp = get_node("MarginContainer/VBoxContainer/HBoxContainer2/JoinIpAddress")
onready var GamePort = get_node("MarginContainer/VBoxContainer/HBoxContainer3/JoinPort")

# Called when the node enters the scene tree for the first time.
func _ready():
    var local_ip_addresses = IP.get_local_addresses()
    local_ip_addresses.sort()
    for ip in local_ip_addresses:
        IpChoices.add_item(ip)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func get_game_port():
    var p = 13021
    if GamePort.text:
        p = int(GamePort.text)
    return p
    
func get_game_ip():
    var ipadd = "localhost"
    if GameIp.text:
        ipadd = GameIp.text
    return ipadd


func _on_JoinGame_pressed():
    emit_signal("join_game")
    

func _on_HostGame_pressed():
    emit_signal("host_game")


func _on_MainReturn_pressed():
    emit_signal("return_to_main_menu")
