extends 'res://scenes/characters/State Machine.gd'

var fsm: StateMachine


onready var next_state = null #use a  state map from the state machine

func enter():
	print("Hello from idle state")
	#Exit 2 seconds later
	yield(get_tree().create_timer(2.0), "timeout")
	
	exit(next_state) 
	print('2222') #for debug purposes

func exit(next_state):
	fsm.change_to(next_state)



func _physics_process(_delta):
	if (
					Input.is_action_pressed("move_down") or
					Input.is_action_pressed("move_left") or
					Input.is_action_pressed("move_right") or
					Input.is_action_pressed("move_up")
		):
		#exit(next_state)
		print('3333') #for debug purposes
	if Input.is_action_just_pressed("attack"):
		#exit(next_state)
		#state.enter('attack')
		print('4444') #for debug purposes
	if Input.is_action_just_pressed("roll"):
		#exit(next_state)
		print('5555') #for debug purposes
	#new_anim = "idle_" + facing
	return _delta

func _notification(what, flag = false):
	return [what, flag]

