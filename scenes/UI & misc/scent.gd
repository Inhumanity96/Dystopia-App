extends Node2D

var player


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.connect("timeout",self, "remove_scent")

func remove_scent():
	player.scent_trail.erase(self)
	queue_free()
