extends Node3D

@export var PlayerScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var index = 0
	#for id in GameManager.Players:
		#var currentPlayer = PlayerScene.instantiate()
		#currentPlayer.id = id
		#add_child(currentPlayer)
#
		#for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoints"):
			#if spawn.name == str(index):
				#currentPlayer.global_position = spawn.global_position
		#index += 1
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
