extends Node

const SERVER_IP = "127.0.0.1"
const SERVER_PORT = 3456

onready var _start_button = get_node("Start_button")
onready var _disconnect_button = get_node("Disconnect_button")
var _connected = false

func _ready():
	get_tree().connect("connected_to_server", self, "_connected_ok")
	initialize_connection()

func initialize_connection():
	$Try_to_connect_to_server_timer.start()
	connect_to_server()
	_start_button.text = "Connecting..."

func connect_to_server():
	print("Try to join the server.")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().set_network_peer(peer)

func _connected_ok():
	$Try_to_connect_to_server_timer.stop()
	Player.set_player_id(get_tree().get_network_unique_id())
	_connected = true
	_start_button.text = "Start"
	_start_button.disabled = false
	_disconnect_button.text = "Disconnect"

func _on_Try_to_connect_to_server_timer_timeout():
	if !_connected:
		connect_to_server()

func disconnect_from_server():
	get_tree().set_network_peer(null)

func _on_Start_button_pressed():
	get_tree().change_scene("res://Scenes/Matchmaking/Lobby/Lobby.tscn")

func _on_Disconnect_button_pressed():
	disconnect_from_server()
	get_tree().change_scene("res://Scenes/Matchmaking/Menu/Menu.tscn")
