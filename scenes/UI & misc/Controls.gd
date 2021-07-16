extends Control
"""
Game settings
"""
#map game settings to save file



func _ready():
	$VBoxContainer/back.grab_focus() #Back button grabs focus

	$TextureRect.hide()

func _on_Button_pressed():
	get_tree().change_scene_to(load('res://scenes/Title screen.tscn')) #changes scene to main title


"""
Turns Music on and off & shuffles current track. Fix code later
"""

#func _on_music_pressed():


	#Music.shuffle() #shuffles music

"""

"""
#toggles Debug panel on and off
func _on_Debug_toggled(button_pressed): 
	if button_pressed:
		Debug.stop_debug()
		$TextureRect2.show() #Shows Debug hint when in debug mode
		$TextureRect.hide()

	else:
		Debug.start_debug()
		$TextureRect2.hide()
		$TextureRect.show()



func _on_Shuffle_pressed():
	#var _o =Music.playlist_one
	#Music.shuffle( )
	print ('shuffle pressed')








func _on_Networking_toggled(button_pressed):
	if Networking.admob != null:
		if button_pressed:
			Networking.admob.hide_banner()
		else:
			Networking.admob.show_banner()


func _on_music_toggled(button_pressed):
	if button_pressed :
		#toggles music on and off
		Music.music_on = false
		Music.notification(NOTIFICATION_PREDELETE)
	else  :
		#Music.notification(NOTIFICATION_UNPAUSED)
		
		#get_tree().get_root().add_child(Music) #doesnt work
		Music.music_on = true
		#Music._initialize()
		#Music.notification(NOTIFICATION_PAUSED)
		#Music._ready()
		#Music.play()
		print('Fix this Feature')


func _on_Help_pressed():
	$"Help popup"._ready()


func _on_Direction_controls_toggled(button_pressed):
	if button_pressed:
		Globals.direction_control = 'analogue'
		$VBoxContainer/Direction_controls.set_text(Globals.direction_control)
	else:
		Globals.direction_control = 'direction'
		$VBoxContainer/Direction_controls.set_text(Globals.direction_control)
