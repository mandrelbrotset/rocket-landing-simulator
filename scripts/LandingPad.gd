# Filename -: LandingPad.gd
# Owner ----: SHERIFF OLAOYE
# Used for controlling the rocket langding pad

extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# get size of the game window
	var screen_size = get_viewport().size
	var pad_position_y = get_viewport().size.y - 30
	
	# generate random x position for the landing pad
	randomize()
	var pad_position_x = rand_range(50.0, 550.0)

	# landing pad for player on the left
	if get_name() == "LandingPad":
		position = Vector2(pad_position_x, pad_position_y)
	# landing pad for player on the right
	elif get_name() == "LandingPad2":
		# single player mode
		if Global.single_player_mode == true:
			# hide second landing pad in single player mode
			queue_free()
		# two player mode
		else:
			# set position for second landing pad
			var x_offset = screen_size.x/2
			position = Vector2(pad_position_x + x_offset, pad_position_y)
