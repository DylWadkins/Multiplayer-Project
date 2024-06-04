extends Control

@export var address = "127.0.0.1"
@export var port = 27015
var peer

# Called when the node is instantiated, we interface with Godot's `multiplayer` api
# We must implement required multiplayer functions (done below),
# then provide a reference to each function through `connect`
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if "--server" in OS.get_cmdline_args():
		hostGame()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	pass

# Called on the peer connecting to the server (and on the server)
func peer_connected(id):
	print("Player Connected " + str(id))
	
# Called on the peer disconnecting from the server (and on the server)
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	GameManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	for player in players:
		if player.name == str(id):
			player.queue_free()
			
# Called on the peer connecting to the server
func connected_to_server():
	print("You connected to the server successfully")
	SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())

# Called on the peer attempting (and failing) to connect to the server
func connection_failed():
	print("You were unable to connect")

# Any peer can call this procedure to update the game state.
@rpc("any_peer")
func SendPlayerInformation(name, id):
	# If there is no player "id" in the game state, create a new entry
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name" : name,
			"id" : id,
			"score": 0
		}
	
	# If the peer is the server, it should send the current game state to each player.
	if multiplayer.is_server():
		for player_id in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[player_id].name, player_id)

# To be called by whoever starts the game ("any_peer")
# It will start the game for everyone, including itself ("call_local")
@rpc("any_peer","call_local")
func StartGame():
	var scene = load("res://Shared/Scenes/Main.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
# The person who hosts the server (also a peer)
func hostGame():
	peer = ENetMultiplayerPeer.new()
	var server_status = peer.create_server(port, 2)
	
	if server_status != OK:
		print("failed to host: " + str(server_status))
		return
	
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting For Players!")
	
# Create a peer upon joining, attempt to connect to `address:port`
func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)	
	pass # Replace with function body.

#
func _on_host_button_down() -> void:
	hostGame()
	SendPlayerInformation($LineEdit.text, multiplayer.get_unique_id())
	pass # Replace with function body.


func _on_start_button_down() -> void:
	StartGame.rpc()
