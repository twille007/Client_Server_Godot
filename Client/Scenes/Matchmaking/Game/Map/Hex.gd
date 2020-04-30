extends Spatial

func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			get_node("/root/Game_manager/Mouse_controller").left_click_on_hex(name)
		
		if event.button_index == BUTTON_RIGHT and event.pressed:
			get_node("/root/Game_manager/Mouse_controller").right_click_on_hex(name)

func set_color(color_id):
	print("color set to " + str(color_id))
	var material = SpatialMaterial.new()
	material.albedo_color = Color(1, 0, 1)
	$Cylinder.set_surface_material(0, material)
	
	
