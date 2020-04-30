extends Control

func _ready():
	for player_id in NetworkingSync._open_games[Player.get_game_id()][3]:
		if player_id != Player.get_player_id():
			rpc_id(player_id, "update_game_room_player_list")
		
	update_game_room_player_list()

remote func update_game_room_player_list():
	NetworkingSync.send_open_games_request_to_server()
	yield(NetworkingSync, "updated_games")

	for child in $Player_list/ScrollContainer/Player_list_container.get_children():
		child.queue_free()
	
	NetworkingSync._player_in_same_game_room_list = []
	
	for player_id in NetworkingSync._open_games[Player.get_game_id()][3]:
		add_player_entry_to_list(player_id)


func add_player_entry_to_list(player_id):
	var player = load("res://Scenes/Matchmaking/Game_room/Player_entry.tscn").instance()
	var player_name = str(NetworkingSync._open_games[Player.get_game_id()][3][player_id][0])
	player.set_player_name(player_name)
	$Player_list/ScrollContainer/Player_list_container.add_child(player)
	var player_info = [player_id, player_name]
	NetworkingSync._player_in_same_game_room_list.append(player_info)

func _on_Game_room_tree_entered():
	if Player._is_host:
		$Start_button.show()
		$Ready_button.hide()
	else:
		$Start_button.hide()
		$Ready_button.hide() # TODO: change this to .show(), if ready-feature is implemented.

func _on_Start_button_pressed():
	for player_id in NetworkingSync._player_in_same_game_room_list:
		if player_id[0] != Player.get_player_id():
			rpc_id(player_id[0], "start_game")
	start_game()

remote func start_game():
	get_tree().change_scene("res://Scenes/Matchmaking/Game/Game_manager.tscn")

func _on_Leave_button_pressed():
	if Player.is_host():
		#TODO: kick everyone out of the game
		NetworkingSync.close_game()
	
	else:
		NetworkingSync.left_game()
		yield(NetworkingSync, "updated_games")
		for player in NetworkingSync._open_games[Player.get_game_id()][3]:
			print(player)
			if player != Player.get_player_id():
				rpc_id(player, "update_game_room_player_list")
	
	Player.set_game_id(0)
	get_tree().change_scene("res://Scenes/Matchmaking/Lobby/Lobby.tscn")
