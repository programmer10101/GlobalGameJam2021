extends Node


var MainMenu = preload("res://scenes/main_menu/MainMenu.tscn")
var MazeEditor = preload("res://scenes/maze_editor/MazeEditor.tscn")
var MazeLevel = preload("res://scenes/maze_level/MazeLevel.tscn")
var MultiplayerMatcher = preload("res://scenes/multiplayer_matching/MultiplayerMatcher.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
    var main_menu = MainMenu.instance()
    add_child(main_menu)
    main_menu.connect("start_sandbox", self, "start_sandbox")
    main_menu.connect("start_multiplayer", self, "start_multiplayer")
    main_menu.connect("quit_game", self, "quit_game")
    


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
    add_child(multiplayer_matcher)
    get_node("MainMenu").queue_free()

func start_maze_level(arr):
    print("Starting Maze Level")
    var maze_level = MazeLevel.instance()
    maze_level.init(arr)
    add_child(maze_level)
    get_node("MazeEditor").queue_free()

func quit_game():
    get_tree().quit()
