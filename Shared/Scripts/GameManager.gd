extends Node

signal player_list_changed()

enum Teams {NONE, TEAM_A, TEAM_B}

var Players : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_num_players() -> int:
	return Players.size()

func has_player(id: int) -> bool:
	return Players.has(id)
	
func get_player(id: int) -> PlayerData:
	return Players.get(id)
	
func create_player(id: int, name: String) -> void:
	Players[id] = PlayerData.new(id, name)
	emit_signal("player_list_changed")

func remove_player(id) -> void:
	Players.erase(id)
	emit_signal("player_list_changed")

func destroy_lobby() -> void:
	Players = {}
	emit_signal("player_list_changed")
