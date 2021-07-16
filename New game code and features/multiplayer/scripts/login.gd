# *************************************************
# godot3-spacegame by Yanick Bourbeau
# Released under MIT License
# *************************************************
# CLIENT-SIDE CODE
#
# Populate the login form and handle callbacks
# on buttons.
#
# *************************************************
extends CanvasLayer

onready var input_color = $ui/grid/input_color #what are these used for?
onready var input_player =$ui/grid/text_player
onready var input_hostname = $ui/grid/text_hostname

func _ready():
	# Adding four spaceship colors
	input_color.add_item("Blue") #tweak this code
	input_color.add_item("Red") #used to separate players into colour codes
	input_color.add_item("Green")
	input_color.add_item("Yellow")
	
	# Set default hostname
	input_hostname.text = Networking.DEFAULT_HOSTNAME
	pass

# Callback function for "Start!" button
func _on_button_login_pressed(): #others join
	
	# Store information about spaceship color and player name #modify #spaceship colour to player colour
	#Networking.cfg_color = input_color.text
	Networking.cfg_player_name = input_player.text
	
	# Lookup hostname and store resolved IP
	Networking.cfg_server_ip = IP.resolve_hostname(input_hostname.text)
	
	# Change to client scene
	if get_tree().change_scene("res://New game code and features/multiplayer/scenes/client.tscn") != OK:
		push_error("Unable to load client scene!")

# Callback function for "Start Server" button
func _on_button_start_server_pressed(): #someone starts the server #inhumanity
	# Change to server scene
	if get_tree().change_scene("res://New game code and features/multiplayer/scenes/server.tscn") != OK:
		push_error("Unable to load server scene!")




func _on_Twitter_Button_pressed():
	OS.shell_open('https://twitter.com/dystopiaO')


func _on_Back_Button_pressed():
	get_tree().change_scene_to(Globals.title_screen)
