extends Control

@export var using_dedicated_server := false
@export var localhost := "127.0.0.1"
@export var server_address := "67.205.156.113"
@export var port : int = 27015
@export var max_players : int = 2

@export var host_button : Button
@export var join_button : Button
@export var lobby_label : Label
@export var lobby_list : ItemList

enum ClientState { ALONE, HOSTING, JOINED }
var client_state = ClientState.ALONE

var level_path := "res://Shared/Scenes/Level.tscn"
var level : PackedScene
var lobby_listing : ItemList
var peer : ENetMultiplayerPeer

# Called when the node is instantiated, we interface with Godot's `multiplayer` api
# We must implement required multiplayer functions (done below),
# then provide a reference to each function through `connect`
func _ready():
	GameManager.player_list_changed.connect(_player_list_changed)
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	multiplayer.server_disconnected.connect(server_disconnected)
	level = load(level_path)
	
	if !using_dedicated_server:
		server_address = localhost
	
	if "--server" in OS.get_cmdline_args():
		host_lobby()

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	pass

# Called on every client (and server) when the peer connects
func peer_connected(id):
	print("Player Connected " + str(id))
	
# Called on every client (and server) when the peer disconnects
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	GameManager.remove_player(id)
	var players = get_tree().get_nodes_in_group("Player")
	for player in players:
		if player.name == str(id):
			player.queue_free()
			
# Called on the client connecting to the server
func connected_to_server():
	print("You connected to the server successfully")
	SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())

# Called on the client attempting (and failing) to connect to the server
func connection_failed():
	print("You were unable to connect")
	
# Called on the client when the server closes
func server_disconnected():
	print("The server has closed")
	leave_lobby()

# Any peer can call this procedure to update the game state.
@rpc("any_peer")
func SendPlayerInformation(name, id):
	# If there is no player "id" in the game state, create a new entry
	if !GameManager.has_player(id):
		GameManager.create_player(id, name)
		
	# If the peer is the server, it should send the current game state to each player.
	if multiplayer.is_server():
		for player_id in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[player_id].name, player_id)

# To be called by whoever starts the game ("any_peer")
# It will start the game for everyone, including itself ("call_local")
@rpc("any_peer","call_local")
func start_game():
	var scene = level.instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	
# The person who hosts the server (also a peer)
func host_lobby():
	peer = ENetMultiplayerPeer.new()
	var server_status = peer.create_server(port, max_players)
	
	if server_status != OK:
		print("failed to host: " + str(server_status))
		return
	
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting For Players!")
	
func join_lobby():
	peer = ENetMultiplayerPeer.new()
	var status = peer.create_client(server_address, port)
	
	if status != OK:
		print("failed to join: " + str(status))
		return
		
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)	
	
func leave_lobby():
	peer.close()
	host_button.disabled = false
	join_button.text = "Join"
	client_state = ClientState.ALONE
	GameManager.destroy_lobby()
	lobby_label.text = "Current Lobby: None"
	
# Attempt to connect to `address:port`, allow the user to leave the server
func _on_join_button_down():
	if client_state == ClientState.ALONE:
		join_lobby()
		host_button.disabled = true
		join_button.text = "Leave"
		client_state = ClientState.JOINED
	else:
		leave_lobby()

#
func _on_host_button_down() -> void:
	if client_state == ClientState.ALONE:
		host_lobby()
		SendPlayerInformation($LineEdit.text, multiplayer.get_unique_id())
		host_button.disabled = true
		join_button.text = "Leave"
		client_state = ClientState.HOSTING
	else:
		leave_lobby()

func _player_list_changed() -> void:
	lobby_label.text = "(%d/%d) Current lobby: %s" % (
		[GameManager.get_num_players(), max_players, server_address]
	)
	lobby_list.clear()
	for player in GameManager.Players:
		var name = GameManager.get_player(player)["name"]
		lobby_list.add_item("%s (%s)" % [name if name else "Player", str(player)])

func _on_start_button_down() -> void:
	start_game.rpc()
