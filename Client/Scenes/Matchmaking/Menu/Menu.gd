extends Node

func _on_Button_pressed():
	connect_to_server()


func _on_LineEdit_text_changed(new_text):
	if len(new_text) <= 0:
		$GUI/Start_button.disabled = true
	else:
		$GUI/Start_button.disabled = false

func _input(ev):
	if Input.is_key_pressed(KEY_ENTER) and not $GUI/Start_button.disabled:
		connect_to_server()

func connect_to_server():
	Player.set_player_name($GUI/LineEdit.text)
	get_tree().change_scene("res://Scenes/Matchmaking/Client/Network_connection.tscn")

func _on_Exit_button_pressed():
	get_tree().quit()
