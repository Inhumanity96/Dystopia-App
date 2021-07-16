extends Node

#Play fx once the scene is ready

func _ready():
	$house_inside/AnimationPlayer.play("flames")
