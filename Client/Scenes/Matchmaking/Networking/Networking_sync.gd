extends Node

signal updated_games
signal all_ready

var _open_games = {}
var _player_in_same_game_room_list = []
var _players_ready = []

func send_open_games_request_to_server():
	rpc_id(1, "get_open_games_from_server", get_tree().get_network_unique_id())

remote func update_open_games(open_games):
	_open_games = open_games
	print(_open_games)
	emit_signal("updated_games")

func get_open_games():
	return _open_games

func create_game(game_information, host_player):
	Player.set_game_id(host_player.get_player_id())
	Player.set_host(true)
	rpc_id(1, "add_game_to_game_list", host_player.get_player_id(), game_information, host_player.get_parsable_player())
	yield(NetworkingSync, "updated_games")
	get_tree().change_scene("res://Scenes/Matchmaking/Game_room/Game_room.tscn")

func join_game(game_id):
	Player.set_game_id(game_id)
	Player.set_host(false)
	rpc_id(1, "join_open_game", game_id, Player.get_parsable_player())
	get_tree().change_scene("res://Scenes/Matchmaking/Game_room/Game_room.tscn")

func left_game():
	rpc_id(1, "remove_player_from_open_game", Player.get_game_id(), Player.get_player_id())
	send_open_games_request_to_server()

func _on_Server_is_reachable_timeout():
	print("Server is reachable.")
	# TODO: check if connection still exists.

func close_game():
	rpc_id(1, "remove_game_from_game_list", Player.get_game_id())

func send_ready_signal():
	if Player.is_host():
		send_host_ready_signal(Player.get_player_id())
	else:
		rpc_id(Player.get_game_id(), "send_host_ready_signal", Player.get_player_id())

remote func send_host_ready_signal(id):
	print(str(id) + " is ready.")
	_players_ready.append(id)
	if len(_players_ready) == len(_player_in_same_game_room_list):
		emit_signal("all_ready")
