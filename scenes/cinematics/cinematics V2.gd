extends Control



# *************************************************
# godot3-Dystopia-game by INhumanity_arts
# Released under MIT License
# *************************************************
#
# This is the cinematics script
# information used by the ciematic scenes .
# organize this code 
# *************************************************




#save resource to a .tres file
#update code to use as videoplayer's base node to play all videos in the scene
signal os_finished_playing
export (bool) var cinematic_on = false
#it only works with ogv files
export(String, FILE, "*.ogv") var vid_stream 
  
var vid_stream_2 
var os
#Ref<ResourceInteractiveLoader> ResourceLoader::load_interactive(String p_path)#experimental code to load resource
onready var animation = $Intro_animation
onready var videoplayer = get_node('Node2D/VideoPlayer') #video player node
 
var cinematic = {
	0:'res://resources/title animation/title..ogv',
	1:'res://scenes/cinematics/animatic.ogv', #convert video to ogv
	}

"""
CINEMATICS
"""
###export your video as ogv format
#update code to reference all in game animations
func _enter_tree():
	os = str(OS.get_name())
	pass  


func _ready(): 
	
	vid_stream = ResourceLoader.load_interactive(cinematic [0]).get_resource() #loads resource into memory 
	if vid_stream == null:
		push_error('vid_stream is null')
	
	#set videoplayer rect size to viewport size
	#videoplayer._set_size((get_viewport_rect().size))
	 
	#OS_play(vid_stream) #buggy
	Video_Stream(vid_stream)
	
func _process(_delta):
	cinematic_debug()

func _on_skip_pressed():
	videoplayer.stop()
	get_tree().change_scene_to(load(Globals.title_screen))

#streamer for android and ios
func OS_play(stream): #buggy
	if os == str('Android'):
		
		OS.native_video_play (stream,20,'','') 
		Debug.misc_debug += 'os playing'
		if OS. native_video_stop() == true:
			emit_signal("os_finished_playing") ; print ('os finished signal')
			Music.clear() 
			Debug.misc_debug += 'os play done'
	else:
		pass

func Video_Stream(stream):
	if stream!= null: #buggy
		
		videoplayer.set_stream(stream) 
		videoplayer.play()   
		cinematic_on= true

	if stream == null :
		push_warning('stream cannot be null')

	if os == null :
		push_warning('OS needed')

# warning-ignore:unused_argument
func _on_Intro_animation_animation_finished(anim_name): #unused animation code
	pass


func cinematic_debug():
	Debug.misc_debug = str(int(videoplayer.stream_position)) + os + str(videoplayer.is_playing(),
	str(vid_stream) + videoplayer.get_stream_name()
	)

func _on_VideoPlayer_finished(): #code breaks here
	#cinematic_on= false
	videoplayer.stop() 
	Music.pause()
	#vid_stream = load(cinematic[1])
	#vid_stream = ResourceLoader.load_interactive(cinematic [1]).get_resource()
	#vid_stream = load(cinematic [1].get_file())
	#vid_stream.get_stage()
	#Video_Stream(vid_stream)   
	
	get_tree().change_scene_to(load(Globals.title_screen))



func _on_Timer_timeout():
	push_error('Cinematic scene broken')
	get_tree().change_scene_to(load(Globals.title_screen))


func _on_Cinematics_os_finished_playing():
	OS_play(vid_stream)
	get_tree().change_scene(Globals.title_screen)

func _exit_tree():
	#Debug.misc_debug = 
	pass
