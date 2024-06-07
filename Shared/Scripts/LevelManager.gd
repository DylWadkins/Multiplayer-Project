extends Node3D

##
## Handles level related logic such as spawning.
##

var player_scene : PackedScene = load("res://addons/fpc/Player.tscn")

func spawn_all_players() -> void:
	for id in GameManager.Players:
		spawn_player(id)
		
# Given the player id and a spawn_pos, attempt to instance the player on all clients
func spawn_player(id) -> void:
	var spawn_pos = get_available_spawnpoint()
	print(spawn_pos)
	if spawn_pos:
		remote_spawn_player.rpc(id, spawn_pos)
	else:
		push_error("Failed to spawn player! This error should get handled eventually.")
		
@rpc("any_peer","call_local")
func remote_spawn_player(id, spawn_pos):
	var player = player_scene.instantiate()
	player.id = id
	add_child(player)
	player.global_position = spawn_pos
	print("Attempting to spawn %d at %s" % [id, str(spawn_pos)])

# Checks all spawn points for a valid spawn location.
func get_available_spawnpoint():
	var spawn_nodes = get_tree().get_nodes_in_group("SpawnNodes")
	spawn_nodes.shuffle()
	for node in spawn_nodes:
		if node.has_spawn():
			return node.get_spawn()
	return null
