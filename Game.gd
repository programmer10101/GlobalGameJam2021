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
var player_info = {}

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
    player_info = {}
    var lobby = MultiplayerLobby.instance()
    lobby.connect("lobby_start_game", self, "on_lobby_start_game")
    lobby.connect("lobby_exit", self, "on_lobby_exit")
    add_child(lobby)
    get_node("MultiplayerMatcher").queue_free()

func on_matcher_join_game():
    game_port = get_node("MultiplayerMatcher").get_game_port()
    game_ip = get_node("MultiplayerMatcher").get_game_ip()
    print("joining game... %s : %s" % [game_ip, game_port])
    # Connect network events
    var _peer_connected = get_tree().connect("network_peer_connected", self, "_on_peer_connected")
    var _peer_disconnected = get_tree().connect("network_peer_disconnected", self, "_on_peer_disconnected")
    var _connected_to_server = get_tree().connect("connected_to_server", self, "_on_connected_to_server")
    var _connection_failed = get_tree().connect("connection_failed", self, "_on_connection_failed")
    var _server_disconnected = get_tree().connect("server_disconnected", self, "_on_server_disconnected")
    # Set up an ENet instance
    var network = NetworkedMultiplayerENet.new()
    network.create_client(game_ip, game_port)
    get_tree().set_network_peer(network)
    start_multiplayer_lobby()
    
func on_matcher_host_game():
    print("hosting game...")
    # Connect network events
    var _peer_connected = get_tree().connect("network_peer_connected", self, "_on_peer_connected")
    var _peer_disconnected = get_tree().connect("network_peer_disconnected", self, "_on_peer_disconnected")
    # Set up an ENet instance
    game_port = get_node("MultiplayerMatcher").get_game_port()
    game_ip = get_node("MultiplayerMatcher").get_game_ip()
    print("host set ip : port ... %s : %s" % [game_ip, game_port])
    var network = NetworkedMultiplayerENet.new()
    network.create_server(game_port, max_players)
    get_tree().set_network_peer(network)
    create_player(1, false)
    start_multiplayer_lobby()
    
func on_matcher_return_to_main_menu():
    get_node("MultiplayerMatcher").queue_free()
    start_main_menu()
    
func on_lobby_start_game(msg):
    print("leaving lobby to start a game", "player %s, opp %s" % [player_id, opponent_id])
    #rpc_id(opponent_id, "register_map_with_opponent", {"id": player_id, "msg": msg})
    start_multiplayer_maze_editor()
    
func on_lobby_exit():
    print("exiting lobby", "player %s, opp %s" % [player_id, opponent_id])
    
func start_maze_level(arr, start, exit):
    print("Starting Maze Level")
    var maze_level = MazeLevel.instance()
    maze_level.init(arr, start, exit)
    add_child(maze_level)
    get_node("MazeEditor").queue_free()
    
remote func register_map_with_opponent(map_info):
    var id = get_tree().get_rpc_sender_id()
    player_info[id] = map_info
    print("playerinfo is ", player_info)

func start_multiplayer_maze_editor():
    print("starting multiplayer maze editor")
    var maze_editor = MazeEditor.instance()
    maze_editor.connect("coord", self, "update_multiplayer_maze_level")
    add_child(maze_editor)
    get_node("MultiplayerLobby").queue_free()
    
func update_multiplayer_maze_level(arr, start, end):
    print("updating multiplayer maze level")
    rpc_id(opponent_id, "register_map_with_opponent", {"id": player_id, "map": arr, "start": start, "exit": end})
    if player_info.has(opponent_id):
        rpc("all_start_multiplayer_maze_level")

remote func start_multiplayer_maze_level():
    print("starting multiplayer maze level")
    var opp_map = player_info[opponent_id]["map"]
    var opp_start = player_info[opponent_id]["start"]
    var opp_exit = player_info[opponent_id]["exit"]
    var maze_level = MazeLevel.instance()
    maze_level.init(opp_map, opp_start, opp_exit)
    add_child(maze_level)
    get_node("MazeEditor").queue_free()
    
remotesync func all_start_multiplayer_maze_level():
    start_multiplayer_maze_level()

func quit_game():
    get_tree().quit()
