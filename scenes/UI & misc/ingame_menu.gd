extends Control


signal menu_hidden
signal menu_showing
export (bool) var enabled 

"""
The game menu script. 
"""
#update code to arrange well in UI and on the game title screen

onready var continue_game = get_node("MarginContainer/ScrollContainer/HSeparator/continue") 
onready var game_menu = get_node("MarginContainer")

onready var _multiplayer = $MarginContainer/ScrollContainer/HSeparator/multiplayer


#func _enter_tree():
	#hide()

func _ready():
	hide()
	
	if Globals.load_game(true) and continue_game != null:
		continue_game.disabled = false 
	else:
		continue_game.disabled = true

func _process(_delta):
	if Debug.debug_panel != null: #turns multiplayer on when debugging
		_multiplayer.show()
	if Debug.debug_panel == null:
		_multiplayer.hide()

func _input(event): #Toggles menu visibility on/off
	if event.is_action_pressed("menu") and enabled == false:
		enabled = true 
		show()
		Music._notification(NOTIFICATION_PAUSED)
		Music.play_track(Music.ui_sfx[0])
		set_focus_mode(2)
		emit_signal("menu_showing")

	elif event.is_action_pressed("menu") and enabled == true:
		enabled = false
		hide()
		Music._notification(NOTIFICATION_UNPAUSED)
		Music.play_track(Music.ui_sfx[1])
		set_focus_mode(0)
		emit_signal("menu_hidden")
		#get_tree().set_pause(false)




func _on_continue_pressed():
	Music.play_track(Music.ui_sfx[0])
	Globals.load_game()
	if Globals.current_level != null:
		if get_tree().change_scene(Globals.current_level) != OK:
			push_error("Error changing scenes")
	else:
		push_error("Error: current_level shouldn't be empty")
	pass # Replace with function body.


func _on_new_game_pressed():
	if Globals.initial_level != "":
		Globals.current_level = Globals.initial_level
		Music.play_track(Music.ui_sfx[0])
		if Globals.save_game() == false:
			push_error("Error saving game")
		var err = get_tree().change_scene(Globals.initial_level)
		if err != OK:
			push_error("Error changing scene: %s" % err)
	else:
		push_error("Error: initial_level shouldn't be empty")
		
	pass # Replace with function body.



func _on_Menu_button_toggled(button_pressed):
	game_menu.show() if button_pressed else game_menu.hide() ;return


	#if  button_pressed :
	#	game_menu.show()
	#else :
	#	game_menu.hide()


func _on_comics_pressed():
	#print_debug ('comics pressed')
	get_tree().change_scene_to(Globals.comics___2)
	Music.play_track(Music.ui_sfx[0])

func _on_controls_pressed():
	get_tree().change_scene_to(Globals.controls)
	Music.play_track(Music.ui_sfx[0])



func _on_quit_Button_pressed():
	if get_tree().get_current_scene().get_name() == 'Menu':
		Music.play_track(Music.ui_sfx[1])
		get_tree().quit()
	else:
		get_tree().change_scene_to(Globals.title_screen)
		Music.play_track(Music.ui_sfx[1])
	#print ('quit button pressed')



func _on_multiplayer_pressed():
	get_tree().change_scene_to(load ('res://New game code and features/multiplayer/scenes/login.tscn'))
	Music.play_track(Music.ui_sfx[0])
	
func _exit_tree():
	Music._notification(NOTIFICATION_UNPAUSED) #resets music when exiting scene tree


func _on_Shop_pressed():
	get_tree().change_scene_to(Globals.shop)
	Music.play_track(Music.ui_sfx[0])


