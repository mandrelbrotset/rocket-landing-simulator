# Filename -: GameResult.gd
# Owner ----: SHERIFF OLAOYE
# Used for controlling game result popup

extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.game_state != "" and visible == false:
		# pasue game physics
		get_tree().paused = true
		
		# make game result overlay visible
		visible = true
		
		# show the winner
		$ResultLabel.text = Global.game_state

# callback function for restart button
func _on_RestartButton_pressed():
	# unpause game physics
	get_tree().paused = false
	
	# reset configuration
	Global.game_state = ""
	
	get_tree().reload_current_scene()

# callback function for main menu button
func _on_MainMenuButton_pressed():
	# reset configurations
	Global.game_state = ""
	Global.single_player_mode = true
	
	# unpause game physics
	get_tree().paused = false
	
	# change to main menu scene
	var path = Global.mainmenu_scene
	get_tree().change_scene(path)

# callback function for quit button
func _on_QuitButton_pressed() -> void:
	get_tree().quit()
