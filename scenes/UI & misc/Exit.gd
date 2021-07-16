extends Area2D

class_name Exit

"""
Add this to any area2d and it will send the player to the indicated scene and spawnpoint
"""

export(String, FILE, "*.tscn") var to_scene = ""
export(String) var spawnpoint = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_body_entered")
	#my code #trying to fix spawnpoint bug
	#if to_scene == Globals.prev_scene :
	#	spawnpoint = Globals.prev_scene_spawnpoint 
#		print ('syncing current spawnpoint to prev spawnpoint')
func _on_body_entered(body):
	if body is Player:
		Globals.current_level = to_scene
		Globals.spawn_x = body.position.x+ 200 
		Globals.spawn_y = body.position.y +200
		Globals.player_hitpoints = body.hitpoints
		Globals.save_game() 
		if  to_scene == "":
			push_error("Error changing scenes: to_scene has no assigned scene")
			return false
		#Globals.prev_scene_spawnpoint = $spawnpoint.position 

		if get_tree().change_scene(to_scene) != OK:
			push_error("Error changing scene")
	pass
