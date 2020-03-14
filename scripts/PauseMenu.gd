# Filename -: PauseMenu.gd
# Owner ----: SHERIFF OLAOYE
# Used for controlling the pause menu popup

extends Control

# Function to process input
func _input(event):
	if event.is_action_pressed('pause'):
		pause_resume()

# callback for resume button
func _on_ResumeButton_pressed():
	pause_resume()

# function to pause or resume game
func pause_resume():
	var pause_state = not get_tree().paused
	get_tree().paused = pause_state
	visible = pause_state

# callback for main menu button
func _on_MenuButton_pressed():
	var path = Global.mainmenu_scene
	get_tree().change_scene(path)

# callback for the restart button
func _on_RestartButton_pressed():
	get_tree().reload_current_scene()

# callback for the quit button
func _on_QuitButton_pressed() -> void:
	get_tree().quit()
