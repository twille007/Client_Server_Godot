extends Spatial

export var _map_width = 12
export var _map_height = 8

var _width_offset = 2.0
var _height_offset = 2.0 * 0.75
var gap = 0.1

var _map = []

func _ready():
	add_gap_between_hexes()
	generate_map()

func calculate_world_position(grid_position):
		var offset = 0
		
		if int(grid_position.y) % 2 != 0:
			offset = _width_offset / 2

		var x = grid_position.x * _width_offset + offset
		var z = grid_position.y * _height_offset

		return Vector3(x, 0, z)

func add_gap_between_hexes():
	_width_offset += _width_offset * gap
	_height_offset += _height_offset * gap

func generate_map():
	for x in range(0, _map_width):
		_map.append([])
		_map[x].resize(_map_height)
		
		for y in range(0, _map_height):
			var hex_node = load("res://Scenes/Matchmaking/Game/Map/Hex.tscn").instance()
			
			var position = (calculate_world_position(Vector2(x,y)))
			
			hex_node.name = "hex_%d_%d" % [x, y]
			hex_node.translation = position
			
			add_child(hex_node)
			_map[x][y] = hex_node
			
