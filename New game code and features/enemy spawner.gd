extends Node

#Enemy spawner code
#Center of an Area2d
var spawn_count = 0
var centerpos
var size
onready var position_in_area = Vector2(0,0) #origin point
var enemy = load('res://scenes/characters/Enemy.tscn') 

onready var position2d = get_node('Area2D/Position2D')
onready var collision_shape = get_node("Area2D/CollisionShape2D")



func _ready():
	randomize()
	print ('spawning enemy...')
	#print(size) #for debug purposes
	spawn_enemy()
	pass

func spawn_enemy(): 
	if spawn_count <= 15:
		spawn_count += 1
		centerpos = position2d.position + collision_shape.position
		
		#Extents of an Area2d (Vector2)
		size = collision_shape.shape.extents
		
		#Get a random position in that Area
		position_in_area.x = (randi()% int(round(size.x))) - int(size.x/2) + centerpos.x
		position_in_area.y = (randi()% int(round(size.y))) - int(size.y/2) + centerpos.y
		#spawn an object in the position
		var spawn = enemy.instance()
		spawn.position = position_in_area
		get_parent().call_deferred('add_child', spawn)
	if spawn_count >= 15:
		return

func _on_enemy_spawner_timeout():
	spawn_enemy()
	pass # Replace with function body.