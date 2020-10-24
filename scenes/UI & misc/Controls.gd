extends Control
"""
Game settings
"""

func _ready():
	$VBoxContainer/Button.grab_focus() #this code breaks something, fix it or remove it


func _on_Button_pressed():
	get_tree().change_scene_to(load('res://scenes/Title screen.tscn')) #changes scene to main title


"""
Turns Music on and off & shuffles current track. Fix code later
"""

func _on_music_pressed():
	Music.shuffle()
	#Input.action_press('Debug') #trying to press the button with code doesnt work
	#$VBoxContainer/music.set_text = str(bool(Music.music_on)
	if Music.music_on == false: 
		Music.music_on = true
	else: Music.music_on =false 

"""
This toggles the Debug panel on and off
"""

func _on_Debug_toggled(button_pressed): #update code to use debug input map instead
	if button_pressed:
		Debug.stop_debug()
	else:
		Debug.start_debug()
