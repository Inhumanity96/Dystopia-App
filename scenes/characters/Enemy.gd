extends KinematicBody2D

class_name Enemy



var run_speed = 100   #mob runspeeed
var velocity = Vector2.ZERO #the movement vector
onready var player =null  #reference to player
var m=0;  #distance variable

 



"""
 the  MOB AI script works on the assumption there will
 be only one player type
"""

"""
This implements a very rudimentary state machine. There are better implementations
in the AssetLib if you want to make something more complex. Also it shares code with Enemy.gd
and probably both should extend some parent script
"""

export(int) var WALK_SPEED = 350
export(int) var ROLL_SPEED = 1000
export(int) var hitpoints = 3

var despawn_fx = preload("res://scenes/UI & misc/DespawnFX.tscn")
var blood_fx = preload("res://scenes/UI & misc/Blood_Splatter_FX.tscn")


var linear_vel = Vector2()
export(String, "up", "down", "left", "right") var facing = "down"

var anim = ""
var new_anim = ""

enum { STATE_IDLE, STATE_WALKING, STATE_ATTACK, STATE_ROLL, STATE_DIE, STATE_HURT }

var state = STATE_IDLE


func _ready():
	randomize()
	#debugs the enemy's codes to a global variable
	Debug.enemy = self 
	#player = get_tree().get_nodes_in_group('player')

func _process(_delta):
	
	#The players position is a vector 2
	if player  != null :
		m= ($hitbox.position).distance_to(player.position) 
		if(m<=4):
			print( 'attack him!'); #place attack code here
			velocity = Vector2.ZERO #catch in movement velocity
	



func _physics_process(_delta):
#NEW CODES

	if player != null:
			velocity = self.position.direction_to(player.position) * run_speed
			velocity = move_and_slide(velocity) #movement to the player
			
	else:
		velocity = 0 #stay in one place if there's no player



	match state:
		STATE_IDLE:
			new_anim = "idle_" + facing
		STATE_WALKING:
			linear_vel = move_and_slide(linear_vel)
			
			var target_speed = Vector2()
			
			if facing == "down":
				target_speed += Vector2.DOWN
			if facing == "left":
				target_speed += Vector2.LEFT
			if facing == "right":
				target_speed += Vector2.RIGHT
			if facing == "up":
				target_speed += Vector2.UP
			
			target_speed *= WALK_SPEED
			linear_vel = linear_vel.linear_interpolate(target_speed, 0.9)
			
			new_anim = ""
			if abs(linear_vel.x) > abs(linear_vel.y):
				if linear_vel.x < 0:
					facing = "left"
				if linear_vel.x > 0:
					facing = "right"
			if abs(linear_vel.y) > abs(linear_vel.x):
				if linear_vel.y < 0:
					facing = "up"
				if linear_vel.y > 0:
					facing = "down"
			
			if linear_vel != Vector2.ZERO:
				new_anim = "walk_" + facing
			else:
				state = STATE_IDLE
			pass
		STATE_ATTACK:
			new_anim = "slash_" + facing
			pass
		STATE_ROLL:
			linear_vel = move_and_slide(linear_vel)
			var target_speed = Vector2()
			if facing == "up":
				target_speed.y = -1
			if facing == "down":
				target_speed.y = 1
			if facing == "left":
				target_speed.x = -1
			if facing == "right":
				target_speed.x = 1
			target_speed *= ROLL_SPEED
			linear_vel = linear_vel.linear_interpolate(target_speed, 0.9)
			new_anim = "roll"
			pass
		STATE_DIE:
			new_anim = "die"
		STATE_HURT:
			new_anim = "hurt"
	


	if new_anim != anim:
		anim = new_anim
		$anims.play(anim)
	pass


func goto_idle():
	state = STATE_IDLE

func _on_state_changer_timeout():
	$state_changer.wait_time = rand_range(1.0, 5.0)
	#state = randi() %3
	state = STATE_ATTACK
	facing = ["left", "right", "up", "down"][randi()%3]
	pass # Replace with function body.


func _on_hurtbox_area_entered(area):
	if state != STATE_DIE and area.name == "player_sword":
		hitpoints -= 1
		var pushback_direction = (global_position - area.global_position).normalized()
		move_and_slide( pushback_direction * 5000)
		state = STATE_HURT
		var blood = blood_fx.instance()
		get_parent().add_child(blood)
		blood.global_position = global_position
		$state_changer.start()
		if hitpoints <= 0:
			$state_changer.stop()
			state = STATE_DIE
	pass # Replace with function body.

func despawn():
	Debug.kill_count += 1
	var despawn_particles = despawn_fx.instance()
	var blood = blood_fx.instance()
	get_parent().add_child(despawn_particles)
	get_parent().add_child(blood)
	despawn_particles.global_position = global_position
	blood.global_position = global_position
	if has_node("item_spawner"):
		get_node("item_spawner").spawn()
	
	get_parent().remove_child(self)
	#self.queue_free()
	pass




#NEW_CODES
# warning-ignore:unused_argument
#m
func _on_enemy_eyesight_body_entered(body):
	if body == Globals.player :
		player = Globals.player
		run_speed = 150 #increase run speed if player is seen
		state= STATE_ATTACK #fix this up
	#if Globals.player.empty() == true:
		pass

func _on_enemy_eyesight_body_exited(body):
	#help detect the player when he leaves
	if body == player:
		run_speed = 120
