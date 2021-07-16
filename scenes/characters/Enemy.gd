extends KinematicBody2D

class_name Enemy



var run_speed = 100   #mob runspeeed
var velocity = Vector2.ZERO #the movement vector
onready var player # = get_tree().get_nodes_in_group('player')  #reference to player
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

export (bool) var mob
var despawn_fx = preload("res://scenes/UI & misc/DespawnFX.tscn")
#export (PackedScene) var blood_fx #= load("res://scenes/UI & misc/Blood_Splatter_FX.tscn")


var linear_vel = Vector2()
export(String, "up", "down", "left", "right") var facing = "down"

var anim = ""
var new_anim = ""

enum { STATE_IDLE, STATE_WALKING, STATE_ATTACK, STATE_ROLL, STATE_DIE, STATE_HURT, STATE_MOB }

var state = STATE_IDLE


func _ready():
	randomize()
	#debugs the enemy's codes to a global variable
	update_facing()#for debug purposes only
	state = STATE_WALKING#for debug purposes only
	
	#Debug.enemy = self 
	if  mob == true: #selcts a player out of the array
		player= get_tree().get_nodes_in_group('player') 
		# Globals.player
		player = player.pop_front() 
		print ('auto mob')
		
	if mob == false:
		player = null

func _process(_delta):
	#update_facing()
	if player != null:
		update_facing()
		#state = STATE_WALKING + STATE_MOB
		#linear_vel = player.position
	#print(state)
	
	pass


func _physics_process(_delta):




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
		STATE_MOB:
			#update_facing()
			#linear_vel = self.position.direction_to(player.position) #* run_speed #my code
			#print (linear_vel)
			
			player =get_tree().get_nodes_in_group('player').pop_front()
			#linear_vel = player.position
			#Globals.player.pop_front()
			#velocity = self.position.direction_to(player.position) * run_speed
			#velocity = move_and_slide(velocity) #movement to the player

			#update_facing()
			var target = player.position  
			var position = self.position 
			var center = restaVectores(target, position)
			
			#update_facing()
			move_and_slide(center)
			#move_and_slide(target.y)
			
			#if abs(position.distance_to(target)) > 200: #if its far...
			##use suma vectores function for vector maths
				#update_facing()
				#move_and_slide(target) #move and slide to center

			if abs(position.distance_to(target)) < 150 :
				
				yield(get_tree().create_timer(rand_range(0,1)), "timeout")
				state= STATE_ATTACK 
				#Kinematic_2d.move_and_slide(target) 
			#	move_and_slide(restaVectores(target,position))
				#print ('player near me: state:', state) #for debug purposes only
				return


			#STATE_WALKING;STATE_ATTACK

	if new_anim != anim:
		anim = new_anim
		$anims.play(anim)
	pass


func goto_idle():
	state = STATE_IDLE

func _on_state_changer_timeout():
	$state_changer.wait_time = rand_range(1.0, 5.0)
	state = randi() %3
	#state = STATE_IDLE
	facing = ["left", "right", "up", "down"][randi()%3]
	#update_facing()
	pass # Replace with function body.


func _on_hurtbox_area_entered(area):
	if state != STATE_DIE and area.name == "player_sword":
		hitpoints -= 1
		Music.play_sfx(Music.hit_sfx)

		var pushback_direction = (global_position - area.global_position).normalized()
		move_and_slide( pushback_direction *   rand_range(2000,10000))
		state = STATE_HURT
		var blood = Globals.blood_fx.instance()
		get_parent().add_child(blood)
		blood.global_position = global_position
		
		$state_changer.start()
		if hitpoints <= 0:
			$state_changer.stop()
			state = STATE_DIE
	
	#if area.name == "hurtbox":
	#	print ('player is near')
	#	state = STATE_ATTACK
	pass # Replace with function body.

func despawn():
	Globals.kill_count +=1
	var despawn_particles = despawn_fx.instance()
	var blood = Globals.blood_fx.instance()
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
	if body is Player :
		#player = body
		run_speed = 150 #increase run speed if player is seen
		state =  STATE_MOB   #+ STATE_WALKING #+STATE_WALKING +STATE_ATTACK #+ STATE_WALKING +STATE_ATTACK #+ STATE_WALKING #fix this up
		#update_facing()
		#state += STATE_WALKING
		print('player seen')
		#print('enemy facing: ',self.position.direction_to(player.position))
	#if Globals.player.empty() == true:
		#pass

func _on_enemy_eyesight_body_exited(body):
	#help detect the player when he leaves
	if body is Player:
		run_speed = 100
		#player = null
		#update_facing()
		state = STATE_WALKING #+ STATE_ATTACK
		print ('player hidden')
func mob():
	#place all new mob codes here
	pass

func update_facing():

	if player != null: #handles enemy facing player
		
		var enemy_direction= (self.position.direction_to(player.position))
		
		var X = round(enemy_direction.x) ; var Y =round (enemy_direction.y)
		if X == 0 and Y == 1:
			facing = 'down'
		if X == 1 and Y == 0:
			facing = 'right'
		if X == -1 and Y == 0:
			facing = 'left'
		if X == 0 and Y == -1:
			facing = 'up'
		#FACING CHEATSHEET
		#DOWN :X=0 , Y =1 [ Y> X] 
		#RIGHT :X= 1, Y= 0 [X > Y ]
		#LEFT: X = -1, Y = 0 [Y>X]
		#UP: X= 0, Y= -1   [X>Y]

func restaVectores(v1, v2): #vector substraction
		return Vector2(v1.x - v2.x, v1.y - v2.y)

func sumaVectores(v1, v2): #vector sum
		return Vector2(v1.x + v2.x, v1.y + v2.y)
