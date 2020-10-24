extends Area2D

class_name Idol

"""
IDOL SCRIPT
this triggers an autosave spawnpoint feature one within its kinematic body 2d
"""


# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_body_entered") #connects the signals with code
	connect("body_exited", self, "_on_body_exited")
	pass # Replace with function body.

func _on_body_entered(body):
	if body is Player:
		Debug.Autosave_debug = str(' Autosaving player position:', body.position ) #improve code to not rely on the globals player script
		
		Globals.spawnpoint = body.position #saves the player's position to spawnpoint
		#Globals.current_level = to_scene #saves the spawnpoint as the current level
			#push_error("Error changing scene")
	pass

func _on_body_exited(body):
	if body is Player:
		Debug.Autosave_debug = str ('')
