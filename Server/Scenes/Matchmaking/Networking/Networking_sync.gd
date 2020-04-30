extends Node
# {game_id:[_game_id, _game_name, _max_players, _player_list]} # player_list is a dict
# {game_id:[_game_id, _game_name, _max_players, {player_id:[_player_name, _player_id, _game_id, _is_host]}]}
var _open_games = {}

var _players_online = []

remote func get_open_games_from_server(id):
	rpc_id(id, "update_open_games", _open_games)

remote func add_game_to_game_list(game_id, game_information, host_player):
	_open_games[game_id] = game_information
	add_player_to_open_game(game_id, host_player)
	get_open_games_from_server(game_id)

remote func join_open_game(game_id, player_information):
	add_player_to_open_game(game_id, player_information)

func add_player_to_open_game(game_id, player_information):
	_open_games[game_id][3][player_information[1]] = player_information

remote func remove_player_from_open_game(game_id, player_id):
	_open_games[game_id][3].erase(player_id)

remote func remove_game_from_game_list(game_id):
	_open_games.erase(game_id)
