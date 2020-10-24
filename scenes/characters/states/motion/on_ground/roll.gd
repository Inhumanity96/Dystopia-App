extends 'res://scenes/characters/State Machine.gd'

var fsm: StateMachine

var roll_direction = Vector2.DOWN
func enter():
	print ("Hello from state roll!")
	#exit 2 seconds later
	yield(get_tree().create_timer(2.0),"timeout")
	exit ('roll')

func exit(next_scene):
	fsm.change_to(next_scene)

func input (event):
	if Input.is_action_just_pressed("roll"):
		state.enter()
		roll_direction = Vector2(
			- int( Input.is_action_pressed("move_left") ) + int( Input.is_action_pressed("move_right") ),
			-int( Input.is_action_pressed("move_up") ) + int( Input.is_action_pressed("move_down") )
				).normalized()
		_update_facing()
		new_anim = "idle_" + facing
	return event
