extends Control

var next_scene= null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$VideoPlayer.play()


func _on_VideoPlayer_finished():
	$VideoPlayer.hide()
	$skip.hide()



func _on_skip_pressed():
	$VideoPlayer.stop()
	$skip.hide()
	get_node("VideoPlayer").free()
	
###this code is to change to another scene calle next_scene
#get_tree().change_scene_to(next_scene)
#queue_free()


#	get_node("VideoPlayer").native_video_play('res://Chapters/chapter 1/intro.ogv')
