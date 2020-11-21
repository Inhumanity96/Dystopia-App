extends Node
class_name StateMachine

#this code introduces wierd printing codes into the scene tree
signal state_changed(current_state)

export(NodePath) var start_state

onready var idle = null
onready var motion = null
onready var jump = null
onready var stagger = null
onready var attack = null


export(String, "up", "down", "left", "right") var facing = "down"

var anim = "" #delete if not needed in state machine
var new_anim = "" #delete if not needed in state machine


const DEBUG = true

var state : Object

var history = []
var states_map = {}


func _ready():
	#Set the initial state to the first child of the node
	state = get_child(0)
	idle = get_parent().get_child(1) #use state map to arrange state codes
	motion = get_parent().get_child(1)
	_enter_state()
#use states map to better organize your code
	states_map = {
		"idle": idle,
		"motion": motion,
		"jump": jump,
		"stagger": stagger,
		"attack": attack,
	}


func change_to (new_state):
	history.append (state.name)
	state = get_node(new_state)
	_enter_state()

func back():
	if history.size() > 0:
		state = get_node(history.pop_back())
		_enter_state()




func _enter_state():
	emit_signal('state_changed')
	if DEBUG:
		#print ('Entering state:' ,state.name)
		pass
	#Give the new state a reference to this state machine script
	#state.fsm = self
	#state.enter()
	#states_map['idle'].enter()
	#Debugging tests for the idle state
	#print (idle)
	#print (state, state.name)
	#print (states_map['idle']) #states map is buggy
	#print ('1234')
	pass
#Route Game Loop Funtion Calls to current state handler method if it exits
func _process(delta):
	if state.has_method('process'):
		state.process(delta)

func _physics_process(delta):
	if state.has_method("physics_process"):
		state.physics_process(delta)

func _input(event):
	if state.has_method("input"):
		state.input(event)

func _unhandled_input(event):
	if state.has_method("unhandled_input"):
		state.unhandled_input(event)

func _unhandled_key_input(event):
	if state.has_method("unhandled_key_input"):
		state.unhandled_key_input(event)
	
func _notification(_what):
	#if state && state.has_method('notification'): this introduces a bug
		#state.notification(what) this introduces a bug
		pass
func _update_facing():
	if Input.is_action_pressed("move_left"):
		facing = "left"
	if Input.is_action_pressed("move_right"):
		facing = "right"
	if Input.is_action_pressed("move_up"):
		facing = "up"
	if Input.is_action_pressed("move_down"):
		facing = "down"
