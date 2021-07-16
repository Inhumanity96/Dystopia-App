extends Position2D

#Enemy spawner code
#Center of an Area2d

#var centerpos
var size
onready var position_in_area = self.position #origin point
var enemy = load('res://scenes/characters/Enemy.tscn') 

#onready var position2d = get_node('Area2D/Position2D')
#onready var collision_shape = get_node("Area2D/CollisionShape2D")

export(int) var spawn_count = -1

func _ready():
	randomize()
	print ('spawning enemy...')
	#print(size) #for debug purposes
	spawn_enemy()
	pass



func spawn_enemy(): 
	if spawn_count <= 12:
		spawn_count += 1

		#spawn an object in the position
		var spawn = enemy.instance()
		$AnimationPlayer.play("spawning")
		spawn.position = position_in_area
		get_parent().call_deferred('add_child', spawn)
	elif spawn_count >= 12:
		return

func _on_enemy_spawner_timeout():
	spawn_enemy()
	pass # Replace with function body.
