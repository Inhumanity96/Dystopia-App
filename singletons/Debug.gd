extends Node



onready var Music_debug 
onready var Player_debug 
onready var Ram_debug 
onready var FPS_debug 
onready var Enemy_debug 
onready var debug_panel = load('res://scenes/characters/debug_panel.tscn')
onready var Comics_debug


"""
This is a debugg panel to debug ingame statistics 
it can be turned off the the settings panel.
"""
#Add signal
func _ready():
	self.start_debug()
	
	

# Called when the node enters the scene tree for the first time.



func _process(_delta):
	"""
	The debugged variables
	"""
	
	#this is debug the variables
	
	Music_debug ='Music debug:' + (Music.music_debug)
	Player_debug ='Player debug:'+ str(Globals.player) + 'Spawn point:' + str(Globals.spawnpoint) + 'Current level: ' + str(Globals.current_level)
	Ram_debug= 'Ram Used :' + (str(float(OS.get_static_memory_usage() ))) + 'bits'
	FPS_debug = 'FPS: '+ str(Engine.get_frames_per_second())
	Enemy_debug = 'Enemy debug:' + str(Globals.enemy_debug)
	

"""
functions that control the debug process
"""

func stop_debug():
	self.set_process(false)
	Music_debug = null
	Player_debug = null
	Ram_debug= null
	FPS_debug= null
	Enemy_debug= null
	print('Debug process stopped Inhumanity-san')
func start_debug():
	self.set_process(true)
	debug_panel.instance() #im trying to instance the debug panel scene
	print('Debug process running Inhumanity-san', Globals.Debug, Debug)
