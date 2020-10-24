extends 'res://scenes/characters/State Machine.gd'
# Collection of important methods to handle direction and animation.
var fsm : StateMachine

func enter():
	print ("Hello from motion state")
	#Exit 2 seconds later
	yield (get_tree().create_timer(2.0),"timeout")
	exit('motion')


func exit(next_state):
	fsm.change_to(next_state)


func handle_input(event):
	if event.is_action_pressed("simulate_damage"):
		emit_signal("finished", "stagger")
		return handle_input(event)

func get_input_direction():
	var input_direction = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	return input_direction


func update_look_direction(direction):
	if direction and owner.look_direction != direction:
		owner.look_direction = direction
