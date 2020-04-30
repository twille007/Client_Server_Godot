extends Node

const SERVER_IP = "127.0.0.1"
const SERVER_PORT = 3456
const MAX_PLAYERS = 1000

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	start_server()

func start_server():
	print("Try to start the server.")
	var peer = NetworkedMultiplayerENet.new()
	var result = peer.create_server(SERVER_PORT, MAX_PLAYERS)
	
	if result != OK:
		print("Failed creating the server.")
		return
	else:
		print("Created the server.")
	
	get_tree().set_network_peer(peer)

func _player_connected(id):
	print(str(id) + " connected to server.")
	NetworkingSync._players_online.append(id)

func _player_disconnected(id):
	print(str(id) + " left the game.")
	NetworkingSync._players_online.erase(id)
	if id in NetworkingSync._open_games:
		NetworkingSync.remove_game_from_game_list(id)
