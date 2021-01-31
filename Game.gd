extends Node


var MainMenu = preload("res://scenes/main_menu/MainMenu.tscn")
var MazeEditor = preload("res://scenes/maze_editor/MazeEditor.tscn")
var MazeLevel = preload("res://scenes/maze_level/MazeLevel.tscn")
var MultiplayerMatcher = preload("res://scenes/multiplayer_matching/MultiplayerMatcher.tscn")
var MultiplayerLobby = preload("res://scenes/multiplayer_lobby/MultiplayerLobby.tscn")

var game_port = 13021
var game_ip = "localhost"
var max_players = 2
var player_id = 0
var opponent_id = 0

func _on_peer_connected(id):
    print("peer connected ", id)
    create_player(id, true)
    
func _on_peer_disconnected(id):
    print("peer disconnected ", id)
    remove_player(id)
    
func _on_connected_to_server():
    print("connected to server")
    var id = get_tree().get_network_unique_id()
    create_player(id, false)    

func _on_connection_failed():
    print("connection failed")
    get_tree().set_network_peer(null)

func _on_server_disconnected():
    print("server disconnected")
    get_tree().reload_current_scene()

func start_main_menu():
    var main_menu = MainMenu.instance()
    add_child(main_menu)
    main_menu.connect("start_sandbox", self, "start_sandbox")
    main_menu.connect("start_multiplayer", self, "start_multiplayer")
    main_menu.connect("quit_game", self, "quit_game")
    
func create_player(id, is_opponent):
    if is_opponent and opponent_id < 1:
        opponent_id = id
    else:
        if player_id < 1:
            player_id = id
            
func remove_player(id):
    if player_id == id:
        player_id = 0
    if opponent_id == id:
        opponent_id = 0
    
    
# Called when the node enters the scene tree for the first time.
func _ready():
    start_main_menu()
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func start_sandbox():
    print("Starting Sandbox")
    var maze_editor = MazeEditor.instance()
    add_child(maze_editor)
    maze_editor.connect("coord", self, "start_maze_level")
    get_node("MainMenu").queue_free()
    
   
func start_multiplayer():
    print("Starting Multiplayer")
    var multiplayer_matcher = MultiplayerMatcher.instance()
    multiplayer_matcher.connect("join_game", self, "on_matcher_join_game")
    multiplayer_matcher.connect("host_game", self, "on_matcher_host_game")
    multiplayer_matcher.connect("return_to_main_menu", self, "on_matcher_return_to_main_menu")
    add_child(multiplayer_matcher)
    get_node("MainMenu").queue_free()
    
func start_multiplayer_lobby():
    print("starting lobby")

func on_matcher_join_game():
    print("joining game...")
    # Connect network events
    var _peer_connected = get_tree().connect("network_peer_connected", self, "_on_peer_connected")
    var _peer_disconnected = get_tree().connect("network_peer_disconnected", self, "_on_peer_disconnected")
    var _connected_to_server = get_tree().connect("connected_to_server", self, "_on_connected_to_server")
    var _connection_failed = get_tree().connect("connection_failed", self, "_on_connection_failed")
    var _server_disconnected = get_tree().connect("server_disconnected", self, "_on_server_disconnected")
    # Set up an ENet instance
    game_port = get_node("MultiplayerMatcher").get_game_port()
    game_ip = get_node("MultiplayerMatcher").get_game_ip()
    var network = NetworkedMultiplayerENet.new()
    network.create_client(game_ip, game_port)
    get_tree().set_network_peer(network)
    
func on_matcher_host_game():
    print("hosting game...")
    # Connect network events
    var _peer_connected = get_tree().connect("network_peer_connected", self, "_on_peer_connected")
    var _peer_disconnected = get_tree().connect("network_peer_disconnected", self, "_on_peer_disconnected")
    # Set up an ENet instance
    game_port = get_node("MultiplayerMatcher").get_game_port()
    game_ip = get_node("MultiplayerMatcher").get_game_ip()
    var network = NetworkedMultiplayerENet.new()
    network.create_server(game_port, max_players)
    get_tree().set_network_peer(network)
    create_player(1, false)
    
func on_matcher_return_to_main_menu():
    get_node("MultiplayerMatcher").queue_free()
    start_main_menu()
    
func on_lobby_start_game():
    print("leaving lobby to start a game")
    
func on_lobby_exit():
    print("exiting lobby")
    
func start_maze_level(arr):
    print("Starting Maze Level")
    var maze_level = MazeLevel.instance()
    maze_level.init(arr)
    add_child(maze_level)
    get_node("MazeEditor").queue_free()

func quit_game():
    get_tree().quit()
