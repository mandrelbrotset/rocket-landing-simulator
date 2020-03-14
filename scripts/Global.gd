# Filename -: Global.gd
# Owner ----: SHERIFF OLAOYE
# Contains game configurations and used for global variables

extends Node

# path to scenes
var mainmenu_scene = "res://scenes/MainMenu.tscn"
var game_scene = "res://scenes/Game.tscn"

var single_player_mode = true

# stores the winner of the level and 
# triggers game result overlay in the process
var game_state = ""

# Rocket configuration
var rocket_position_y = 30.0
var thrustable_angle = 80
var fuel = 120