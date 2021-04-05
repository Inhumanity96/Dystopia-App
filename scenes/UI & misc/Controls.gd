extends Control
"""
Game settings
"""

func _ready():
	$VBoxContainer/Button.grab_focus() #this code breaks something, fix it or remove it

	$TextureRect.hide()

func _on_Button_pressed():
	get_tree().change_scene_to(load('res://scenes/Title screen.tscn')) #changes scene to main title


"""
Turns Music on and off & shuffles current track. Fix code later
"""

func _on_music_pressed():
#toggles music on and off
	Music.notification(NOTIFICATION_PREDELETE)

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
	Music.shuffle()
	








func _on_Networking_toggled(button_pressed):
	if button_pressed:
		pass#Networking.enabled = !enabled

