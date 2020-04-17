extends Control


var is_popup_menu_showing = null
var game_popup_menu


#####im writing code to optimize the scene loading process

func _ready():
	game_popup_menu = get_node("GamePopupMenu")
	is_popup_menu_showing = false










func _on_quit_Button_pressed():
	game_popup_menu.hide()
	get_tree().quit()














func _on_TouchScreenButton_pressed():
	if is_popup_menu_showing == false :
		game_popup_menu.show()
		is_popup_menu_showing = true
	elif is_popup_menu_showing == true :
		game_popup_menu.hide()
		is_popup_menu_showing = false











func _on_chap_1_button_pressed():
	get_tree().change_scene_to(Globals.chap_1)
	queue_free()


func _on_chap_2__pressed():
	get_tree().change_scene_to(Globals.chap_2)
	queue_free()


func _on_music_on__off_pressed():
	Music.free()
	pass


func _on_mini_game_pressed():
	get_tree().change_scene_to(Globals.game_title)
	queue_free()

