extends MultiplayerSpawner

## Here we are overriding the default spawn function in the 
## MultiplayerSpawner class to augment spawn behavior with
## setting multiplayer authority and additional spawn logic

var player_scene : PackedScene = load("res://addons/fpc/Player.tscn")

## Initialize the spawner
func _enter_tree() -> void:
	self.spawn_function = _spawn_player

## Our custom function called on MultiplayerSpawner.spawn()
func _spawn_player(id: int):
	#print("Spawning ", id, " on ", multiplayer.get_unique_id())
	var player := player_scene.instantiate()
	player.id = id
	#if multiplayer.is_server():
		#print("=== IS SERVER ===")
		#print("Player position was ", player.position)
	player.position = _get_available_spawnpoint()
		#print("Player position is now ", player.position)
	player.set_multiplayer_authority(id)
	return player

## To be called by the server once a level is loaded
func spawn_all_players() -> void:
	for id in GameManager.Players:
		spawn_player(id)
		
	print("Spawned all players!")

## May be called by the server when a peer connects 
func spawn_player(id: int) -> Node:
	# The id here will get sent to other peers on spawn automatically
	return self.spawn(id)

static var index = 0
func _get_available_spawnpoint():
	var spawn_nodes = get_tree().get_nodes_in_group("SpawnNodes")
	var deterministic_spawn
	if spawn_nodes[index].has_spawn():
		deterministic_spawn = spawn_nodes[index].get_spawn()
	index += 1
	return deterministic_spawn
	
#func _get_available_spawnpoint():
	#var spawn_nodes = get_tree().get_nodes_in_group("SpawnNodes")
	#spawn_nodes.shuffle()
	#for node in spawn_nodes:
		#if node.has_spawn():
			#return node.get_spawn()
	#print("We got null?")
	#return Vector3.ZERO
