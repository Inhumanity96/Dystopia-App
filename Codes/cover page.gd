extends Node2D


var dots = null
var is_popup_menu_showing = null
var game_popup_menu




func _ready():
	game_popup_menu = get_node("Game menu/GamePopupMenu")
	is_popup_menu_showing = false
	dots = get_node("Dystopia Button/AnimationPlayer/dots")






func _on_TouchScreenButton_pressed():
	if is_popup_menu_showing == false :
		game_popup_menu.show()
		is_popup_menu_showing = true
	elif is_popup_menu_showing == true :
		game_popup_menu.hide()
		is_popup_menu_showing = false










