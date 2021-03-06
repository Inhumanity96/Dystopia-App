extends Node
#lists of labels being used by the debug panel
onready var music_label 
onready var player_label 
onready var ram_label
onready var fps_label
onready var enemy_label
onready var network_label
onready var comics_label
onready var autosave_label
onready var misc_label
onready var globals_label

#class_name Debug
export (bool) var enabled 

onready var Autosave_debug ='' 
onready var Music_debug 
onready var Player_debug 
onready var Ram_debug 
onready var FPS_debug 
onready var Enemy_debug 
onready var debug_panel  
onready var Comics_debug = ''
onready var misc_debug = ''
onready var kill_count = 0
onready var enemy = ''
onready var Network_debug =''
onready var Globals_debug
"""
THE DEBUG SINGLETON
"""
#Add signal
func _ready():
	start_debug()
	#stop_debug()
	"""
	Error catcher
	"""
	if enabled == true and debug_panel == null:
		push_error("Error getting Debug panel")
		print_debug( 'Instancing Debug panel') #Fix this piece of code, to create the labels with code




## Called when the node enters the scene tree for the first time.

func _input(event): 
	"""
	functions that control the debug process
	"""
	if event.is_action_pressed("Debug") and debug_panel != null: #stops the debug code #catch the error that occurs
		stop_debug()
	elif event.is_action_pressed("Debug") and debug_panel == null:
		start_debug()
func _process(_delta):

	"""
	The debugged variables
	"""
	#add more variables
	enabled = true
	Music_debug ='Music debug:' + (Music.music_debug)
	Player_debug ='Player debug:'+ str(Globals.player) + 'Spawn point:' + str(Globals.spawnpoint) + 'Current level: ' + str(Globals.current_level) 
	
	#it uses the ram_mb funtion to convert bytes to mb
	Ram_debug= ('Ram Used :'+ ((_ram_debug())) + 'mb') 
	FPS_debug = 'FPS: '+ str(Engine.get_frames_per_second())
	Enemy_debug = 'Enemy debug:' + str('Killcount:' , Globals.kill_count)
	Autosave_debug = Autosave_debug
	
	Network_debug =  str(Networking.debug ) 
	
	
	misc_debug = str(misc_debug)
	Globals_debug='Direction type' + '/'+ str(Globals.direction_control)
	
	show_debug() 
	





func _ram_debug():
	#This code gets the current ram being used as bytes 
	#and converts it to MB and rounds up the final figure
	var ram_mb = String(round(float(OS.get_static_memory_usage()) / 1_048_576))
	
	return ram_mb


func stop_debug():
	if debug_panel != null:
		debug_panel.queue_free()
		debug_panel = null
		enabled = false
		Music_debug = null
		Player_debug = null
		Ram_debug= null
		FPS_debug= null
		Enemy_debug= null
		Network_debug = null
		misc_debug = null
		enabled = false
func start_debug(): 
	enabled = true
	#creates and loads dynamic fonts
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load('res://fonts/spiritmedium.ttf')
	dynamic_font.size = 26
	dynamic_font.outline_size = 2
	dynamic_font.outline_color= Color(0,0,0,1)
	dynamic_font.use_filter = true
	#label.add_colour_override('font_colour', Color.red) 
	#changes font colour # look up how to change colour modulation on a vbox
	#Create new labels and add them as children of the debug panel 
	#optimize code to use less words
	debug_panel =CanvasLayer.new() #works
	#add debug layer as child of debug singleton #fixes touch input bug
	get_tree().get_root().get_node("/root/Debug").call_deferred('add_child',debug_panel) 
	debug_panel.add_to_group('debug') #adds to a group, dont know if it works
	#set draw order
	debug_panel.set_layer(1) 

	var vbox = VBoxContainer.new()
	debug_panel.add_child(vbox) #draws vbox on screen
	#sets mouse filter to ignore' fixes startup bug
	#print(vbox.get_mouse_filter())
	vbox.set_mouse_filter(2)
	
	music_label = Label.new()
	player_label = Label.new()
	ram_label= Label.new()
	fps_label= Label.new()
	enemy_label= Label.new()
	network_label= Label.new()
	comics_label= Label.new()
	autosave_label= Label.new()
	misc_label =Label.new()
	globals_label = Label.new()
	vbox.add_child(music_label) #update code to use for loop
	vbox.add_child(player_label)
	vbox.add_child(ram_label)
	vbox.add_child(fps_label)
	vbox.add_child(enemy_label)
	vbox.add_child(network_label)
	vbox.add_child(comics_label)
	vbox.add_child(autosave_label)
	vbox.add_child(misc_label)
	vbox.add_child(globals_label)
	#add font data #use label.rect_size.x and .y= 100 to manually increase label size
	#vbox.ALIGN_CENTER #aligns vbox to center #fix code
	music_label.add_font_override('font', dynamic_font) #adds dynamc font data
	player_label.add_font_override('font', dynamic_font) #use a forloop for this
	ram_label.add_font_override('font', dynamic_font)
	fps_label.add_font_override('font', dynamic_font)
	enemy_label.add_font_override('font', dynamic_font)
	network_label.add_font_override('font', dynamic_font)
	comics_label.add_font_override('font', dynamic_font)
	autosave_label.add_font_override('font', dynamic_font)
	misc_label.add_font_override('font', dynamic_font)
	globals_label.add_font_override('font', dynamic_font)
	


func show_debug():
	if debug_panel != null :
		music_label.set_text (Music_debug) 
		player_label.set_text (Player_debug)
		ram_label.set_text (Ram_debug) 
		fps_label.set_text (FPS_debug)
		enemy_label.set_text (Enemy_debug)
		network_label.set_text (Network_debug)
		comics_label.set_text  (Comics_debug)
		autosave_label.set_text (Autosave_debug)
		misc_label.set_text( misc_debug)
		globals_label.set_text(Globals_debug)
	if debug_panel != null and enabled: 
		return
	if debug_panel == null and !enabled :
		push_error('error getting debug panel')

func _print_debug(): #use to debug variables to terminal og
	print (FPS_debug,Music_debug,Ram_debug, enabled)

func log_debug(): #improvve logging code run at exit tree  #Copy log files to documents
	if ProjectSettings.get_setting('logging/file_logging/enable_file_logging'):
		var _doc = OS.get_system_dir(2) 
		var _dir =Directory.new()
		var _log = File.new()
		_log.open('user://logs/godot.log', File.READ_WRITE)
		
		
		_dir.copy(_log,_doc) #buggy
		#('user://logs/godot.log' from, _doc to)
		print ('Doc:',_doc,'  log: ', _log) #works
		#print ('logging debug, saved to  ', _doc)
		#_log.close()
		pass

func _exit_tree():
	#log_debug()
	pass
