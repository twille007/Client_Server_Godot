extends Node

var _player_id
var _player_name
var _game_id
var _is_host

func set_player_name(player_name):
	_player_name = player_name

func set_player_id(player_id):
	_player_id = player_id

func set_host(is_host):
	_is_host = is_host

func is_host():
	return _is_host

func get_player_name():
	return _player_name

func get_player_id():
	return _player_id

func set_game_id(game_id):
	_game_id = game_id

func get_game_id():
	return _game_id

func get_parsable_player():
	return [_player_name, _player_id, _game_id, _is_host]
