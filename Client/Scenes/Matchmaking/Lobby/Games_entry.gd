extends Button

var _game_name
var _max_players
var _game_id

func set_game_id(game_id):
	_game_id = game_id

func set_game_name(game_name):
	_game_name = game_name

func set_max_players(max_players):
	_max_players = max_players

func update_gui():
	$HBoxContainer/Game_name.text = _game_name
	$HBoxContainer/Number_of_player.text = str(len(NetworkingSync._open_games[_game_id][3])) + "/" + str(_max_players)

func _on_Games_entry_pressed():
	NetworkingSync.send_open_games_request_to_server()
	yield(NetworkingSync, "updated_games")
	if _game_id in NetworkingSync._open_games and !is_full():
		NetworkingSync.join_game(_game_id)

func is_full():
	var number_of_players = len(NetworkingSync._open_games[_game_id][3])
	return number_of_players >= _max_players
