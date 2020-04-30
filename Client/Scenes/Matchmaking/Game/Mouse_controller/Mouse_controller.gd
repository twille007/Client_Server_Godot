extends Spatial

var _selected_hex
var _selected_meeple

var _game_manager
var _map

func _ready():
	_game_manager = get_node("/root/Game_manager")


func left_click_on_hex(hex_name):
	_selected_hex = hex_name
	print(hex_name)
	
	if _game_manager.is_my_turn() and _game_manager.ability_left():
		_game_manager.color_the_hex(hex_name)

func right_click_on_hex(hex_name):
	print("Right click")
