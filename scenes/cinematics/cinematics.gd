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





class_name cinematic


#save resource to a .tres file
#update code to use as videoplayer's base node to play all videos in the scene
signal os_finished_playing
export (bool) var cinematic_on = true
#it only works with ogv files
export(String, FILE, "*.ogv") var vid_stream = ""
   

#Ref<ResourceInteractiveLoader> ResourceLoader::load_interactive(String p_path)#experimental code to load resource
onready var animation = $Intro_animation
onready var videoplayer = get_node('Node2D/VideoPlayer') #video player node
onready var os 
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
	#self.MOUSE_FILTER_IGNORE = 2
	

func _ready(): #create a video player function
	vid_stream = ResourceLoader.load_interactive(cinematic [0]) #loads resource into memory 
	if vid_stream == null:
		push_error('vid_stream is null')
	
	#set videoplayer rect size to viewport size
	videoplayer._set_size((get_viewport_rect().size))
	Debug.misc_debug = os
	OS_play(vid_stream)
	Video_Stream(vid_stream)




func _process(_delta):
	#vid_stream = ResourceLoader.load_interactive(cinematic [0])
	#Video_Stream(vid_stream)
	pass


	pass
func _on_skip_pressed():
	videoplayer.stop()
	get_tree().change_scene(Globals.title_screen)

func OS_play(stream): #streamer for android and ios
	if os == str('Android'):
		stream = stream.get_resource()
		OS.native_video_play (stream.get_file(),20,'','') #code not working
		Debug.misc_debug += 'os playing'
		if OS. native_video_stop() == true:
			emit_signal("os_finished_playing") ; print ('os finsihed signal')
			#get_tree().change_scene(Globals.title_screen) #changes scene to title screen
			Music.clear() 
			Debug.misc_debug += 'os play done'


func Video_Stream(stream): #This code works
	if os != str('Android') && stream!= null:
		stream = stream.get_resource()
		videoplayer.set_stream(stream) 
		videoplayer.play() ; cinematic_on= true

# warning-ignore:unused_argument
func _on_Intro_animation_animation_finished(anim_name): #unused animation code
	#get_tree().change_scene(Globals.title_screen)
	#Music.clear()
	pass

func change_cinematic(): #automatic cinematic changer
	pass

func _on_VideoPlayer_finished():
	vid_stream = '' 
	change_cinematic() #not working
	vid_stream = ResourceLoader.load_interactive(cinematic [1])
	Video_Stream(vid_stream)   
	Music.pause() 
	cinematic_on= false



func _on_Timer_timeout():
	push_error('Cinematic scene broken')
	get_tree().change_scene(Globals.title_screen)
	self.queue_free() #autodelete


func _on_Cinematics_os_finished_playing():
	change_cinematic()
