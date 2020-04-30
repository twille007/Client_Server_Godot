extends Spatial
 
const MOVE_MARGIN = 20
const MOVE_SPEED = 15

const X_BORDER_LIMIT = 8
const X_MAP_OFFSET = 2

const Z_BORDER_LIMIT = 3
const Z_MAP_OFFSET = 1

onready var cam = $Camera
 
func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	calc_move(mouse_position, delta)
 
func calc_move(mouse_position, delta):
	var screen_size = get_viewport().size
	var position = translation
   
	if mouse_position.x < MOVE_MARGIN:
		position.x -= MOVE_SPEED * delta
		
	if mouse_position.y < MOVE_MARGIN:
		position.z -= MOVE_SPEED * delta
		
	if mouse_position.x > screen_size.x - MOVE_MARGIN:
		position.x += MOVE_SPEED * delta
		
	if mouse_position.y > screen_size.y - MOVE_MARGIN:
		position.z += MOVE_SPEED * delta
		
	position.x = clamp(position.x, -X_BORDER_LIMIT, X_BORDER_LIMIT + X_MAP_OFFSET)
	position.z = clamp(position.z, -Z_BORDER_LIMIT - Z_MAP_OFFSET, Z_BORDER_LIMIT - Z_MAP_OFFSET)
	translation = position
