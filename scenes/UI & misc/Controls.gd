extends Control
"""
Game settings
"""

func _ready():
	$VBoxContainer/Button.grab_focus() #this code breaks something, fix it or remove it
	$VBoxContainer/Debug.text = 'Debug'
	if Debug.debug_panel == null:
		push_error("Error getting Debug panel")


func _on_Button_pressed():
	get_tree().change_scene_to(load('res://scenes/Title screen.tscn')) #changes scene to main title



"""
This toggles the Debug panel on and off. Fix code up later
"""
func _on_Debug_toggled(button_pressed):
	if button_pressed:
		Debug.start_debug()
		$VBoxContainer/Debug.text = 'Debug on'
	else:
		 Debug.stop_debug(); $VBoxContainer/Debug.text = 'Debug off'









