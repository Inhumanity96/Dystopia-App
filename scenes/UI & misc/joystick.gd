extends Control


##################################################
#Improve the state changer
#Pressing the stick direction again helps to clear it

###############JoyStick Controller################
var joystick_debug
var touchInsideJoystick #= false
var maxlength

onready var __input =InputEventAction.new()

var x
var y

onready var the_action

onready var the_event

onready var joystick_circle = $joystick_circle
onready var outer_circle = $joystick_circle2

enum {MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT, RELEASE}


export var state = 4

func _ready():
	#__input.action = ''
	#__input.pressed = false
	#__input.accumulate()
	pass
func release(): #pass it a variable
	#######reseting functionr#########   #it is the release state as a function 
	#the previous action gets stuck in the scene tree as input
	#print('reset digital joystick') #for debug purposes only1
	
	#print ('reset digital joystick: ',the_event, the_action )
	__input.pressed = false
	#touchInsideJoystick = false
	#__input.action = ''
	Input.parse_input_event(__input)
	#Input.action_release(__input.action)
	#state = 4
	


func _input(event):
	if event is InputEventScreenDrag :
		#print(str((event.get_relative())))  #for debug purposes only
		the_event = event
		#Input.set_use_accumulated_input(true)

		#__input = InputEventAction.new()
		#print(event.as_text()) #for debug purposes
		#print (the_event)
		
		if touchInsideJoystick == true:
			#start_debug()
			#######sets joystic circle to touch event direction ############
			joystick_circle.pos.x = joystick_circle.pos.x + event.relative.x
			joystick_circle.pos.y = joystick_circle.pos.y + event.relative.y
				
				
			maxlength = outer_circle.circle_size - joystick_circle.circle_size
	################################################################# 

	###################Clamps the Joystick cirle withing a radius#############################
			if joystick_circle.pos.length() > maxlength:
				var angle = joystick_circle.pos.angle()
				joystick_circle.pos.x = cos(angle) * maxlength 
				joystick_circle.pos.y = sin(angle) * maxlength

			x = round(joystick_circle.pos.x/maxlength) #divide x and y by max length
			y = round(joystick_circle.pos.y/maxlength)

############################Joystick Analogue Controls controls here####################
		if joystick_circle.is_pressed()== true :
			if x == (1) and y == (0) : 
				#release() 
				state =MOVE_RIGHT
			if x == (-1) and y ==(0): 
				#release()
				state = MOVE_LEFT
			if x == (0) and y ==(1) :
				#release()
				state = MOVE_DOWN
			if x == (0) and y == (-1) : 
				#release()
				state = MOVE_UP
			if x == abs(0) and y == abs(0)  : 
				state = RELEASE #The directional controls work here and above works
			else:
				#state = RELEASE
				#release()
				pass
		if joystick_circle.is_pressed()== false:
			state = RELEASE
###################################################################################################
		 #####The 8 directional analogur code is working



###################Input Action State Machine#####################################
		match state:
			MOVE_UP: #improve your state machine
				#release()
				__input.action = 'move_up'
				__input.pressed =true
				__input.strength = abs(y)
				Input.parse_input_event(__input)
				the_action = __input.action 
				start_debug()
				#state = 0
				the_action = __input.action
				return the_action
				#print(__input.as_text()) #for debugging release
				if x ==(1) and y ==(-1) : 
					state = MOVE_RIGHT
				if x == (-1) and y == (-1):
					state = MOVE_LEFT
				if x == (0) and y ==(1) :
					state = MOVE_DOWN
				if x == abs(0) and y == abs(0)  : 
					state = RELEASE
					
			MOVE_DOWN:
				#release()
				__input.action = 'move_down'
				__input.pressed =true
				__input.strength = abs(y)
				Input.parse_input_event(__input)
				the_action = __input.action
				start_debug()
				#state = 1
				the_action = __input.action
				return the_action
				#print(__input.as_text()) #for debugging release
				if x == (1) and y == (1):
					state = MOVE_RIGHT
				if x == (-1) and y == (1):
					state = MOVE_LEFT
				if x == (0) and y == (-1)  : 
					state = MOVE_UP
				if x == abs(0) and y == abs(0)  : 
					state = RELEASE
				else:
					state = RELEASE
					#release()
			MOVE_RIGHT:
				#release()
				__input.action = 'move_right'
				__input.pressed =true
				__input.strength = abs(x)
				Input.parse_input_event(__input)
				the_action = __input.action
				start_debug()
				#state = 2
				the_action = __input.action
				return the_action
				#print(__input.as_text()) #for debugging release
				#reset()
				if x == (-1) and y ==(0): 
					state = MOVE_LEFT
				if x == (0) and y ==(1) :
					state = MOVE_DOWN
				if x == (0) and y == (-1) : 
					state = MOVE_UP
				if x == abs(0) and y == abs(0) : 
					state = RELEASE
				else:
					state = RELEASE
					#release()
			MOVE_LEFT:
				#release()
				__input.action = 'move_left'
				__input.pressed = true
				__input.strength = abs(x)
				Input.parse_input_event(__input)
				start_debug()
				#state = 3
				the_action = __input.action
				return the_action
				#print(__input.as_text()) #for debugging release
				#reset()
				if x == (1) and y == (0) :
					state = MOVE_RIGHT
				if x == (0) and y == (-1) : 
					state = MOVE_UP
				if x == (0) and y ==(1) :
					state =  MOVE_DOWN
				if x == abs(0) and y == abs(0)  : 
					state = RELEASE
				else:
					state = RELEASE
					#release()
			RELEASE: #this is buggy it introduces a stuck button bug
				release()
				if the_action != null: #write two inputs at the same time error code #THeres a stuc button bug
					#print(the_action) #two actions stacking introduces bug
					if __input.is_action_pressed(the_action) == true: #if my action pressed is true
						if __input.get_action_strength(the_action) != 0:
							__input.pressed =false #stuck button bug
							__input.strength = 0
							#reset()
							#print('The current action',the_action) #for debug purposes only
							Input.parse_input_event(__input)
					Input.action_release(the_action); update()
					#state = 4
					stop_debug()
					
					return the_action
	##############################################################################


		if touchInsideJoystick == false:
			release()







#######Resets Joystick if event is released##############################
	if event is InputEventScreenTouch and event.pressed == false:
		joystick_circle.pos.x = 0
		joystick_circle.pos.y = 0

		
		state = 4  
		touchInsideJoystick = false
		
		release()
		#stop_debug()
		return __input
	if event is InputEventScreenTouch and event.pressed == true: #add a douch colision that is the size of joystick outter circle
		touchInsideJoystick = true
		#state = RELEASE #buggy
		#start_debug()


func start_debug():
###############________Debugs the Joystick Node__________########################S
	if touchInsideJoystick == true:
		joystick_debug = str(
			'Joypad Debug')+ '/'+'x ' +str(x) + ',' +'y ' +str(y) + ' state: '+str (state) + '/'+' Touch inside Joystick:'+ str(touchInsideJoystick)+ '/'+ 'Input Action: '+str(__input.action + 'Pressed: '+ str(__input.pressed) +'/'# + str(the_event)
			)
	#print (joystick_debug) #disable when not debugging
		Debug.misc_debug = joystick_debug
		#print(__input.as_text(), the_event) #for debugging release

func stop_debug():
	joystick_debug = str ('')
	Debug.misc_debug = joystick_debug





