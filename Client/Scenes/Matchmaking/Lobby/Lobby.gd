extends Control

const MIN_PLAYERS = 2
const MAX_PLAYERS = 8
const MIN_GAME_NAME_LENGTH = 1
const MAX_GAME_NAME_LENGTH = 20

func _on_Refresh_button_pressed():
	refresh_game_list()

func refresh_game_list():
	NetworkingSync.send_open_games_request_to_server()
	yield(NetworkingSync, "updated_games")
	for child in $Lobby/Games_list/Open_games/VBoxContainer.get_children():
		child.queue_free()
	
	for game in NetworkingSync.get_open_games().values():
		add_entry_to_lobby(game[0], game[1], game[2])

func add_entry_to_lobby(game_id, game_name, max_players):
	var new_game = load("res://Scenes/Matchmaking/Lobby/Games_entry.tscn").instance()
	new_game.set_game_id(game_id)
	new_game.set_game_name(game_name)
	new_game.set_max_players(max_players)
	new_game.name = "Game_entry_" + game_name
	new_game.update_gui()
	$Lobby/Games_list/Open_games/VBoxContainer.add_child(new_game)

func _on_Create_game_button_pressed():
	$Lobby.hide()
	$Lobby_game_creation_panel.show()

func _on_Ok_button_pressed():
	create_game_room()

func _on_Cancel_button_pressed():
	$Lobby_game_creation_panel.hide()
	$Lobby.show()

func _on_Exit_button_pressed():
	get_tree().change_scene("res://Scenes/Matchmaking/Menu/Menu.tscn")

func _on_Lobby_controller_tree_entered():
	refresh_game_list()

func _on_Game_name_line_edit_text_changed(new_text):
	check_input_fields()

func _on_Number_of_players_line_edit_text_changed(new_text):
	check_input_fields()

func is_number_of_players_text_field_ok():
	var result = false
	var text_field = $Lobby_game_creation_panel/HBoxContainer2/Number_of_players_line_edit.text
	if int(text_field) >= MIN_PLAYERS and int(text_field) <= MAX_PLAYERS:
		result = true
	return result

func is_game_name_text_field_ok():
	var result = false
	var text_field = $Lobby_game_creation_panel/HBoxContainer/Game_name_line_edit.text
	if len(text_field) <= MAX_GAME_NAME_LENGTH and len(text_field) >= MIN_GAME_NAME_LENGTH:
		result = true
	return result

func check_input_fields():
	if is_number_of_players_text_field_ok() and is_game_name_text_field_ok():
		$Lobby_game_creation_panel/Ok_button.disabled = false
	else:
		$Lobby_game_creation_panel/Ok_button.disabled = true

func _input(ev):
	if Input.is_key_pressed(KEY_ENTER) and not $Lobby_game_creation_panel/Ok_button.disabled:
		create_game_room()

func create_game_room():
	var game_name = $Lobby_game_creation_panel/HBoxContainer/Game_name_line_edit.text
	var max_players = int($Lobby_game_creation_panel/HBoxContainer2/Number_of_players_line_edit.text)
	var game_id = get_tree().get_network_unique_id()
	NetworkingSync.create_game([game_id, game_name, max_players, {}], Player)
