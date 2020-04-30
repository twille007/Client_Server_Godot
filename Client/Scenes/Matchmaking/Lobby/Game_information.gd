extends Node

var _game_id
var _game_name
var _max_players
var _player_list

func _init(game_id, game_name, max_players):
	_game_id = game_id
	_game_name = game_name
	_max_players = max_players
	_player_list = {}

func get_parsable_game_information():
	return [_game_id, _game_name, _max_players, _player_list]

func add_player_to_game(player):
	_player_list.append(player)

func remove_player_from_game():
	pass

func set_game_id(game_id):
	_game_id = game_id

func set_game_name(game_name):
	_game_name = game_name

func set_max_players(max_players):
	_max_players = max_players

func is_full():
	return _max_players <= len(_player_list)
