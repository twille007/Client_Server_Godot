extends Spatial

var _current_player_index

var _other_players = []

var _map

func _ready():
	_other_players = NetworkingSync._player_in_same_game_room_list.duplicate()
	_other_players.erase([Player.get_player_id(), Player.get_player_name()])
	init_game()
	
	if Player.is_host():
		init_game_state()
	
	NetworkingSync.send_ready_signal()
	$GUI/Debug_label.text = "My id: " + str(Player.get_player_id()) + ", others: " + str(_other_players)

func init_game():
	create_map()

func create_map():
	_map = load("res://Scenes/Matchmaking/Game/Map/Map.tscn").instance()
	add_child(_map)

func init_game_state():
	yield(NetworkingSync, "all_ready")
	print("Yea!, all ready")
	var starting_player_index = calculate_stating_player_index()
	
	set_starting_player(starting_player_index)
	for player in _other_players:
		rpc_id(player[0], "set_starting_player", starting_player_index)

func is_my_turn():
	return NetworkingSync._player_in_same_game_room_list[_current_player_index][0] == Player.get_player_id()

func calculate_stating_player_index():
	return int(rand_range(0, len(NetworkingSync._player_in_same_game_room_list)))

remote func set_starting_player(starting_player_index):
	print("set starting playerindex: " + str(starting_player_index))
	_current_player_index = starting_player_index
	$GUI/Top_panel/Top_panel_container/Player_indicator.text = str(NetworkingSync._player_in_same_game_room_list[_current_player_index][1])
	if is_my_turn():
		$GUI/Bottom_left_panel/VBoxContainer/Next_turn_button.disabled = false
	else:
		$GUI/Bottom_left_panel/VBoxContainer/Next_turn_button.disabled = true

func _on_Next_turn_button_pressed():
	next_player()
	for player in _other_players:
		rpc_id(player[0], "next_player")

remote func next_player():
	print("Current playerindex: " + str(_current_player_index))
	_current_player_index = (_current_player_index + 1) % len(NetworkingSync._player_in_same_game_room_list)
	$GUI/Debug_label.text = str(_current_player_index) + ", " +  str(len(NetworkingSync._player_in_same_game_room_list))
	$GUI/Top_panel/Top_panel_container/Player_indicator.text = str(NetworkingSync._player_in_same_game_room_list[_current_player_index][1])
	if is_my_turn():
		$GUI/Bottom_left_panel/VBoxContainer/Next_turn_button.disabled = false
	else:
		$GUI/Bottom_left_panel/VBoxContainer/Next_turn_button.disabled = true

func color_the_hex(hex_name):
	for player in _other_players:
		rpc_id(player[0], "color_the_hex_to_player_color", hex_name)
	color_the_hex_to_player_color(hex_name)

remote func color_the_hex_to_player_color(hex_name):
	_map.get_node(hex_name).set_color(_current_player_index)

func ability_left():
	return true
