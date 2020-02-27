extends Node2D

var next_scene= preload ("res://Chapters/cover page.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_back_pressed():
	get_tree().change_scene_to(next_scene)
	queue_free() ; next_scene = null
