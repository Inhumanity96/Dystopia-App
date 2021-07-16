# *************************************************
# godot3-Dystopia-game by INhumanity_arts
# Released under MIT License
# *************************************************
#
# This is a auto-included singleton containing
# information used by the Game 
#
# *************************************************

extends Node
#update code to use global dictionaries

#use variables to code ux +add a scene calculator
var cinematics #= load ('res://scenes/levels/cinematics.tscn')
var title_screen = preload( 'res://scenes/Title screen.tscn')
var shop = load('res://scenes/UI & misc/Shop.tscn')
var controls = load ('res://scenes/UI & misc/Controls.tscn')
var comics
var comics___2 = load ('res://scenes/UI & misc/Comics____2.tscn')
var game_loop
var prev_scene
var prev_scene_spawnpoint
var next_scene = null
onready var curr_scene #= get_tree().get_current_scene().get_name()
onready var os = str(OS.get_name())
onready var kill_count = 0 #update to load from savefile
export var player  = []
var player_hitpoints
var enemy = null
var enemy_debug
export(String, FILE, "*.tscn") var initial_level  = "res://scenes/levels/Outside.tscn" 
var Debug = null
var _player_state # gets state data from the player state machine


export (int) var Suds #currency system
# warning-ignore:unused_class_variable
export (Vector2) var spawnpoint 
var spawn_x
var spawn_y
var current_level 

var blood_fx = load ('res://scenes/UI & misc/Blood_Splatter_FX.tscn')


var direction_control = '' #toggles btw analogue and d-pad
func _ready():
	print('Blood fx:',blood_fx)
	

	
	player.append( get_tree().get_nodes_in_group('player') )#gets all player nodes in the scene
	if player.empty() == true: #error catcher 1             #it shows deleted object once player is despawns. Fix pls
		player = null
	
	
	
	VisualServer.set_default_clear_color(ColorN("white"))
	
	#while (comics == null):
	#	var comics_group = get_tree().get_nodes_in_group('Cmx_Root')
	#	if not comics_group.empty():
	#		comics = comics_group.pop_front()
	#	else:
	#		pass


func _process(_delta):
	if spawn_x and spawn_y != null:
		spawnpoint =Vector2(spawn_x,spawn_y)
	if player_hitpoints == int (0):
		player_hitpoints = 1 #stops the game from saving zero lives
	
	#enemy_debug = enemy_debug #updates the enemy debug variable
	pass


"""
Really simple save file implementation. Just saving some variables to a dictionary
"""
func save_game(): #modify code to include current scene and player position. also enemy spawner postions and info
	var save_game = File.new()
	save_game.open("user://savegeme.save", File.WRITE)
	var save_dict = {}
	save_dict.player = player #saves the player node 
	#save_dict.spawnpoint = spawnpoint
	save_dict.spawn_x = spawn_x
	save_dict.spawn_y =spawn_y
	save_dict.current_level = current_level
	save_dict.inventory = Inventory.list()
	save_dict.quests = Quest.get_quest_list()
	#my code
	save_dict.os = os
	save_dict.kill_count = kill_count
	save_dict.currency = Suds
	save_dict.prev_scene = prev_scene
	save_dict.prev_scene_spawnpoint = prev_scene_spawnpoint
	save_dict.player_hitpoints = player_hitpoints
	#save_dict.direction_control = direction_control
	#save_dict. #add other variables to save
	
	save_game.store_line(to_json(save_dict))
	save_game.close()
	pass

"""
If check_only is true it will only check for a valid save file and return true or false without
restoring any data
"""
func load_game(check_only=false):
	var save_game = File.new()
	
	if not save_game.file_exists("user://savegeme.save"):
		return false
	
	save_game.open("user://savegeme.save", File.READ)
	
	var save_dict = parse_json(save_game.get_line())
	if typeof(save_dict) != TYPE_DICTIONARY:
		return false
	if not check_only:
		_restore_data(save_dict)
	
	save_game.close()
	return true

"""
Restores data from the JSON dictionary inside the save files
"""
func _restore_data(save_dict):
	# JSON numbers are always parsed as floats. In this case we need to turn them into ints
	for key in save_dict.quests:
		save_dict.quests[key] = int(save_dict.quests[key])
	Quest.quest_list = save_dict.quests
	
	# JSON numbers are always parsed as floats. In this case we need to turn them into ints
	for key in save_dict.inventory:
		save_dict.inventory[key] = int(save_dict.inventory[key])
	Inventory.inventory = save_dict.inventory
	
	spawn_x = save_dict.spawn_x 
	spawn_y = save_dict.spawn_y
	current_level = save_dict.current_level
	
	player = save_dict.player
	
	os = save_dict.os 
	kill_count = save_dict.kill_count 
	Suds = save_dict.currency 
	player_hitpoints = save_dict.player_hitpoints
	prev_scene =save_dict.prev_scene 
	prev_scene_spawnpoint = save_dict.prev_scene_spawnpoint 
	#direction_control = save_dict.direction_control
	pass
	
	
func update_curr_scene():
	curr_scene= get_tree().get_current_scene().get_name() 
