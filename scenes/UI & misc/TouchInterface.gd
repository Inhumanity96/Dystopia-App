extends Node2D
"""
A State Machine for the touch interface to hint player and not clutter the ui
"""

export (bool) var Touch_os_enabled
#var Touch_interface = self
onready var menu = $menu
onready var interract = $interact
onready var stats = $stats
onready var roll = $roll
onready var slash = $slash
onready var up = $up
onready var down = $down
onready var left = $left
onready var right = $right
onready var comics = $comics
onready var joystick = $Joystick


export(String, "menu", "interract", "attack", "stats", 'comics', 'reset') var state 
export (String, 'analogue', 'direction') var _control
func _ready():
#Changes D-pad Controls from control
	if Globals.direction_control != '':
		_control = Globals.direction_control

#toggles touch interface visibility depending on the os
	if Globals.os != str('Android') or str('ios'):
		if Touch_os_enabled == true:
			self.hide()
			#for _e in get_parent().get_node("TouchInterface").get_children():
			#	if _e is TouchScreenButton:
			#		_e.hide()
			print('Hiding touch interface', Globals.os)

#########Auto sets the controller button

	reset()

func reset():  #resets node visibility statuses
	state = 'reset'
	#for child in get_children():
	#	child.show()
	stats.show()
	menu.show()
	interract.show()
	comics.show()
	slash.show()
	roll.show()
	if _control == 'analogue':
		joystick.show()
		up.hide()
		down.hide()
		left.hide()
		right.hide()
	if _control == 'direction':
		joystick.hide()
		up.show()
		down.show()
		left.show()
		right.show()


func status():  #used by ui scene when status is clicked
	state = 'status'
	if Touch_os_enabled == false :
		stats.show()
		menu.hide()
		right.hide()
		left.hide()
		up.hide()
		down.hide()
		joystick.hide()
		interract.hide()
		comics.hide()
		slash.hide()
		roll.hide()
		

func comics():  #used by ui scene when comics is clicked
	if Touch_os_enabled == false:
		stats.hide()
		menu.hide()
		right.hide()
		left.hide()
		up.hide()
		down.hide()
		joystick.hide()
		interract.hide()
		comics.show()
		slash.hide()
		roll.hide()
		state = 'comics'
func menu(): #used by ui scene when menu is clicked
	if Touch_os_enabled == false: #include analogue controls
		stats.hide()
		menu.show()
		right.hide()
		left.hide()
		up.hide()
		down.hide()
		joystick.hide()
		interract.hide()
		comics.hide()
		slash.hide()
		roll.hide()
		state = 'menu'

func interract(): #used by ui scene when interract is clicked
	state = 'interract'
	if Touch_os_enabled == false:
		stats.hide()
		menu.show()
		right.hide()
		left.hide()
		up.hide()
		down.hide()
		joystick.hide()
		interract.show()
		comics.hide()
		slash.hide()
		roll.hide()
		

func attack(): #used by ui scene when attack is clicked
	state = 'attack'
	if Touch_os_enabled == false:
		stats.hide()
		menu.show()
		interract.hide()
		comics.hide()
		slash.show()
		roll.show()
		if _control == 'analogue':
			right.hide()
			left.hide()
			up.hide()
			down.hide()
			joystick.show()
		if _control == 'direction':
			joystick.hide()
			right.show()
			left.show()
			up.show()
			down.show()

