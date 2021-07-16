extends Node

#Auto sets player spawnpoint once scene is rendered
func _ready():
	for child in get_children():
		if child is Player :
			child.spawnpoint = Globals.spawnpoint
