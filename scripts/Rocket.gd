# Filename -: Rocket.gd
# Owner ----: SHERIFF OLAOYE
# Used for controlling the rockets

extends RigidBody2D

var impulse_y = -1
var impulse_x = 0.4
var fuel = Global.fuel              # get the allocated fuel from configuration file
var vert_velocity_queue = []        # queue to store vertical velocity of rocket
var max_queue_length = 20           # maximum number of velocity to track
var crashed = false                 # rocket has crashed or not
var default_player = false          # player on the left is the default player

# Function that stores the rockets vertical velocity in a queue
func add_to_queue(y_velocity):
	vert_velocity_queue.append(y_velocity)

    # remove items from queue to maintain queue max size
	if len(vert_velocity_queue) > max_queue_length:
		vert_velocity_queue.remove(0)
		

# Function that calculates the average vertical velocity of the rocket
func average_vertical_velocity():
	var sum = 0
	for i in vert_velocity_queue:
		sum += i
		
	return sum/len(vert_velocity_queue)


# Called when the node enters the scene tree for the first time.
func _ready():
	# seed random number generator
	randomize()
		
	if get_name() == "Rocket":
		default_player = true
		
		var rocket_position_x = rand_range(60.0, 640.0)
		position = Vector2(rocket_position_x, Global.rocket_position_y)
	elif get_name() == "Rocket2":
	# check if game is in single player mode
		if Global.single_player_mode == true:
			# hide second player rocket(Rocket 2) in single player mode
			queue_free()
		else:
			var x_offset = get_viewport().size.x/2
			var rocket_position_x = rand_range(60.0, 640.0)
			position = Vector2(rocket_position_x + x_offset, Global.rocket_position_y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	# store vertical velocity of the rocket
	var y_velocity = get_linear_velocity()[1]
	add_to_queue(y_velocity)
	
	var crash_angle = 40.0
	var rotation_ = get_global_rotation_degrees()
	
	if rotation_ < (-1)*crash_angle or rotation_ > crash_angle:
		explode_rocket("Rocket crashed")
	
	var max_landing_angle = 5
	# get items rocket is colliding with
	var colliding_bodies = get_colliding_bodies()
	
	for body in colliding_bodies:
        # check if object collided with a landing pad
		if body.get_name().substr(0, 10) != "LandingPad":
			explode_rocket("Rocket crashed")
		# if rocket is upright
		# rocket cannot land on the side
		elif rotation_ > (-1)*max_landing_angle and rotation_ < max_landing_angle:
			if average_vertical_velocity() < 50.0 and crashed == false:
				rocket_landed()
			else:
				explode_rocket("Rocket crashed!")

	# set fuel label
	if default_player:
		get_node("../../GameStats/FuelLabel1").text = "Fuel: " + str(fuel)
	else:
		get_node("../../GameStats/FuelLabel2").text = "Fuel: " + str(fuel)


# Function to handle events after rocket has crashed
func explode_rocket(message):
	if default_player == true:
		if Global.single_player_mode:
			Global.game_state = message
		else:
			# set label to show if player has crashed
			get_node("../../GameStats/Player1Stat").text = message
			fuel = 0
			crashed = true
	else:
		# set label to show if player has crashed
		get_node("../../GameStats/Player2Stat").text = message
		crashed = true
		fuel = 0


# Function to handle events after rocket has landed
func rocket_landed():
	# set variable to trigger result screen
	if default_player == true:
		# for player on the left
		if Global.single_player_mode:
			Global.game_state = "Rocket landed successfully!"
		else:
			Global.game_state = "Player 1 wins!"
	else:
		# for player on the right
		Global.game_state = "Player 2 wins!"


# Function to process keyboard input
func get_input():
	var rotation_ = get_global_rotation_degrees()
	var impulsePoint = Vector2(0.0, $CollisionShape2D.shape.extents.y - $CollisionShape2D.shape.extents.y/3)
	
	# keyboard mappings are defined in game engine config
	# change mapping based on rocket being controlled
	var left = "player2_left"
	var right = "player2_right"
	var up = "player2_up"

	if default_player:
		left = "player1_left"
		right = "player1_right"
		up = "player1_up"

	# make rocket move to the left
	if Input.is_action_pressed(left) and fuel > 0:
			apply_impulse(impulsePoint, Vector2((-1)*impulse_x, 0))
			
	# make rocket move to the right
	if Input.is_action_pressed(right) and fuel > 0:
			apply_impulse(impulsePoint, Vector2(impulse_x, 0))
	
	# on pressing up button, fire up the engines and make rocket go up
	if Input.is_action_pressed(up) and fuel > 0 and (rotation_ > (-1)*Global.thrustable_angle) and (rotation_ < Global.thrustable_angle):
		# decrease fuel
		fuel -= 1
		
		# play flame animation
		$Flame.visible = true
		$Flame/Animation.play("FlameAnimation")
		# make rocket go up
		apply_impulse(impulsePoint, Vector2(0, impulse_y))
	else:
		# stop flame animation
		$Flame.visible = false

# Called every frame when about to process game physics
# warning-ignore:unused_argument
func _physics_process(delta):
	get_input()