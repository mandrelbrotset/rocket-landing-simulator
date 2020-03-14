# Filename -: MenuControl.gd
# Owner ----: SHERIFF OLAOYE
# Used for Controlling the main menu

extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$SinglePlayerBtn.pressed = true

# callback function for start game button
func _on_StartGameBtn_pressed():
	var path = Global.game_scene
	get_tree().change_scene(path)

# callback function for single player checkbox
func _on_SinglePlayerBtn_toggled(button_pressed):
	# toggle single player and two player checkbox
	$SinglePlayerBtn.pressed = true
	$TwoPlayersBtn.pressed = false
	
	Global.single_player_mode = true

# callback function for single player checkbox
func _on_TwoPlayersBtn_toggled(button_pressed):
	# toggle single player and two player checkbox
	$SinglePlayerBtn.pressed = false
	$TwoPlayersBtn.pressed = true
	
	Global.single_player_mode = false

# callback function for quit button
func _on_QuitButton_pressed() -> void:
	get_tree().quit()
