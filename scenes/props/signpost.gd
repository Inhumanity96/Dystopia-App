extends Area2D


"""
Displays A Dialogue Text When the Player comes near
"""

export (int) var shown = 0 # it runs as a oneshot

export(String) var dialogue #signpost dialogue

export (bool) var _player_near 
func _ready():
	#shown = false
	connect("area_entered", self, "_on_player_area_entered")
	connect("area_exited", self, "_on_player_area_exited")
	Dialogs.connect("dialog_started", self, "_on_dialog_started")
	Dialogs.connect("dialog_ended", self, "_on_dialog_ended")
	pass




func _on_dialog_ended():
	$"/root/Dialogs".dialog_box.hide()



func _input(_event):
	if Input.is_action_pressed("interact")  && _player_near == true: 
		print('signpost clicked') #for debug purposes only
		if shown <= 1: #a counting variable
			$"/root/Dialogs".dialog_box.show_dialog('shshshshshs', 'Aarin') #doesnt work
			get_tree().paused = true#works
			yield(get_tree().create_timer(1.0), "timeout") #works
			$"/root/Dialogs".dialog_box.hide_dialogue() 
			get_tree().paused = false
			shown += 1
		if shown ==2 :
			pass




func _on_player_area_entered(body):
	#print('_on_player_area_entered_ functin running', body.get_parent().name)
	if  body.get_parent().name == 'Player' :
		_player_near = true
		print ('player near signpost: ', _player_near)

func _on_player_area_exited(body):
	if  body.get_parent().name == 'Player' :
		_player_near = false
		print ('player near signpost: ', _player_near)
