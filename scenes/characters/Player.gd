extends KinematicBody2D

class_name Player

"""
This implements a very rudimentary state machine. There are better implementations
in the AssetLib if you want to make something more complex. Also it shares code with Enemy.gd
and probably both should extend some parent script
"""



export(int) var WALK_SPEED = 350 # pixels per second
export(int) var ROLL_SPEED = 1000 # pixels per second
export(int) var hitpoints = 3

export var linear_vel = Vector2()
export var roll_direction = Vector2.DOWN

signal health_changed(current_hp)

export(String, "up", "down", "left", "right") var facing = "down"


var despawn_fx = preload("res://scenes/UI & misc/DespawnFX.tscn")
#export (PackedScene) var blood_fx #= load("res://scenes/UI & misc/Blood_Splatter_FX.tscn")

var anim = ""
var new_anim = ""

enum { STATE_BLOCKED, STATE_IDLE, STATE_WALKING, STATE_ATTACK, STATE_ROLL, STATE_DIE, STATE_HURT }

export var state = STATE_IDLE

onready var player_camera = $camera #the player's camera
# Move the player to the corresponding spawnpoint, if any and connect to the dialog system

func _enter_tree():
	Globals.update_curr_scene()
	if Globals.player_hitpoints != null:
		hitpoints = Globals.player_hitpoints #Updates player health across scenes
	if Globals.player != null:
		if Globals.player.empty() == true  :
			Globals.player.append(self)  #saves player to the player variable

	#print (Globals.spawnpoint)

func _ready():



	"""
	Autospawn Code
	"""
	#Globals.load_game()
	
	if Globals.spawnpoint is Vector2 and Globals.spawnpoint != null: #auto spawn code
		if Globals.curr_scene == 'Outside' :
			if Globals.current_level != null:
				self.position = Globals.spawnpoint
				print ('auto spawn')
		if Globals.curr_scene == 'HouseInside':
			pass

		#break
	if not (
			Dialogs.connect("dialog_started", self, "_on_dialog_started") == OK and
			Dialogs.connect("dialog_ended", self, "_on_dialog_ended") == OK ):
		printerr("Error connecting to dialog system")
	
	pass


func _process(_delta):
	#####this updates the player's node to a globals variable
	Globals._player_state = state

	#print ('Current scene:',Globals.curr_scene, 'Current level',Globals.current_level) #for debug purposes only
	
func _physics_process(_delta):



	
	
	## PROCESS STATES
	match state:
		STATE_BLOCKED:
			new_anim = "idle_" + facing
			pass
		STATE_IDLE:
			if (
					Input.is_action_pressed("move_down") or
					Input.is_action_pressed("move_left") or
					Input.is_action_pressed("move_right") or
					Input.is_action_pressed("move_up")
				):
					state = STATE_WALKING
			if Input.is_action_just_pressed("attack"):
				state = STATE_ATTACK
			if Input.is_action_just_pressed("roll"):
				state = STATE_ROLL
				roll_direction = Vector2(
						- int( Input.is_action_pressed("move_left") ) + int( Input.is_action_pressed("move_right") ),
						-int( Input.is_action_pressed("move_up") ) + int( Input.is_action_pressed("move_down") )
					).normalized()
				_update_facing()
			new_anim = "idle_" + facing
			#get_material().
			pass
		STATE_WALKING:
			if Input.is_action_just_pressed("attack"):
				state = STATE_ATTACK
			if Input.is_action_just_pressed("roll"):
				state = STATE_ROLL
			
			linear_vel = move_and_slide(linear_vel)
			
			var target_speed = Vector2()
			
			if Input.is_action_pressed("move_down"):
				target_speed += Vector2.DOWN
			if Input.is_action_pressed("move_left"):
				target_speed += Vector2.LEFT
			if Input.is_action_pressed("move_right"):
				target_speed += Vector2.RIGHT
			if Input.is_action_pressed("move_up"):
				target_speed += Vector2.UP
			
			target_speed *= WALK_SPEED
			#linear_vel = linear_vel.linear_interpolate(target_speed, 0.9)
			linear_vel = target_speed
			roll_direction = linear_vel.normalized()
			
			_update_facing()
			
			if linear_vel.length() > 5:
				new_anim = "walk_" + facing
			else:
				goto_idle()
			pass
		STATE_ATTACK:
			new_anim = "slash_" + facing
			pass
		STATE_ROLL:
			if roll_direction == Vector2.ZERO:
				state = STATE_IDLE
			else:
				linear_vel = move_and_slide(linear_vel)
				var target_speed = Vector2()
				target_speed = roll_direction
				target_speed *= ROLL_SPEED
				#linear_vel = linear_vel.linear_interpolate(target_speed, 0.9)
				linear_vel = target_speed
				new_anim = "roll"
				if Input.is_action_just_pressed("attack"): #punch and slide
					state = STATE_ATTACK
		STATE_DIE:
			new_anim = "die"
		STATE_HURT:
			new_anim = "hurt"
	
	## UPDATE ANIMATION
	if new_anim != anim:
		anim = new_anim
		$anims.play(anim)
	pass


func _on_dialog_started():
	state = STATE_BLOCKED

func _on_dialog_ended():
	state = STATE_IDLE


## HELPER FUNCS
func goto_idle():
	linear_vel = Vector2.ZERO
	new_anim = "idle_" + facing
	state = STATE_IDLE


func _update_facing():
	if Input.is_action_pressed("move_left"):
		facing = "left"
	if Input.is_action_pressed("move_right"):
		facing = "right"
	if Input.is_action_pressed("move_up"):
		facing = "up"
	if Input.is_action_pressed("move_down"):
		facing = "down"


func despawn():  #this code breaks
	var blood = Globals.blood_fx.instance()
	var despawn_particles = despawn_fx.instance()
	
	
	get_parent().add_child(despawn_particles)
	get_parent().add_child(blood) 
	despawn_particles.global_position = global_position
	blood.global_position = global_position
	hide()
	print ('Update Player code for proper despawing')
	yield(get_tree().create_timer(5.0), "timeout")
	#Update this code to update player position
	
	get_tree().reload_current_scene() #This code reboots the game
	
	#removes itself from Globals.player
	pass


func _on_hurtbox_area_entered(area):
	if state != STATE_DIE and area.is_in_group("enemy_weapons"):
		hitpoints -= 1
		emit_signal("health_changed", hitpoints)
		var pushback_direction = (global_position - area.global_position).normalized()
		move_and_slide( pushback_direction * 5000)
		state = STATE_HURT
		var blood = Globals.blood_fx.instance()
		blood.global_position = global_position
		get_parent().add_child(blood)
		
		if hitpoints <= 0:
			state = STATE_DIE
	pass
