# *************************************************
# godot3-Dystopia-game by INhumanity_arts
# Released under MIT License
# *************************************************
#
# This is the random item spawner script
# information used by the enemy and player nodes .
# 
# *************************************************

extends Position2D

"""
Add this to any node. spawn instances an Item.tscn node with the defined values
"""
#rewrite code to load from inspector tab
#add multiple instances for weapons, xtra health and generic stuff

export (PackedScene) var spawn_1
export (PackedScene) var spawn_2
export (PackedScene) var spawn_3
export (PackedScene) var item_scene  #use export packed scene
export(String) var item_type = "Generic Item"
export(int) var amount = 1

export (bool) var random_spawn
onready var _spawn = [spawn_1,spawn_2,spawn_3]

func _ready():
	if random_spawn == false:
		print('loading default item')
		print ('Default item: ',item_scene)


func spawn(): #organize this code to switch btw random spawn and single spawn
	if random_spawn == false:
		if item_scene == null:
			push_error('default spawn item cannot be null')
			item_scene= load("res://scenes/items/Item.tscn")
		
	if random_spawn == true:
		_spawn.shuffle()
		item_scene = _spawn.pop_back()
	
	var item = item_scene.instance() 
	owner.get_parent().add_child(item)
	item.global_position = global_position
	item.item_type = item_type
	item.amount = amount
	pass
