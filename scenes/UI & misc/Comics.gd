# *************************************************
# godot3-Dystopia-game by INhumanity_arts
# Released under MIT License
# *************************************************
#
# This is a pluggin containing
# information used by the comics placeholder codes.
#
# *************************************************

extends Control 

export (bool) var enabled = false
export (bool) var can_drag = false #Variable for the drag function
"""
COMICS PLACEHOLDER CODE. IT INHERITS FROM A CONTROL NODE

"""
var comics = {
	 1: 'res://scenes/Comics/chapter 1/chapter 1.tscn',
	2:'res://scenes/Comics/chapter 2/chapter 2.tscn',
	3:'res://scenes/Comics/chapter 3/chapter 3.tscn'
}

var memory = {}

var current_frame  #=$placeholder.get_sprite_frames() 

var next_scene = null
var max_frame 
var current_comics
onready var zoom = false
onready var comics_placeholder#The comics placeholder sprite

onready var animation = $AnimationPlayer #use this to program transitions
onready var texture
onready var area2d = $Area2D #the area 2d node for drag and drop
onready var position 
onready var center
onready var target =Vector2() #set position to the center of the viewport
onready var Touch_page = false
func _ready():
	"""
	ERROR CATCHER 
	"""
	if target == null: #catches a null error in the drag and drop codes
		target = Vector2()
		push_error('target cannot be null')
	load_comics()

"""
DRAG AND DROP
"""

func _input(event): 
#Toggles comics visibility on/off
	if event.is_action_pressed("comics") and enabled == false:
		enabled = true 
		Music._notification(NOTIFICATION_PAUSED) #does not work
	elif event.is_action_pressed("comics") and enabled == true:
		enabled = false
		Music._notification(NOTIFICATION_UNPAUSED) #does not work
	if (can_drag == false and Input.is_action_pressed("ui_select")): 
		can_drag = true
	if (can_drag == true and Input.is_action_pressed("ui_select")):
		drag() #calls up the drag function
	else:
		can_drag = false #this block of code works
	# Handle Touch
	if event is InputEventScreenTouch:
		if event.is_pressed() and !can_drag:
			drag() ; can_drag = true
		if !event.is_pressed():
			can_drag = false


	# Handles ScreenDragging
	if event is InputEventScreenDrag:
		if event.is_pressed() and !can_drag:
			drag() ; can_drag = true

# Handles releasing 

	#no code yet

# Handles double clicking

	if event is InputEventMouseButton && event.doubleclick && !zoom:
		print ('double click')
		$Area2D/placeholder.set_scale(Vector2(0.3,-0.3)) ; zoom = true 
	elif event is InputEventMouseButton && event.doubleclick && zoom :
		$Area2D/placeholder.set_scale(Vector2(0.12,-0.13)) ; zoom = false

#Comic panel changer

	if event.is_action_pressed("ui_focus_next"):
		next_panel()
	if event.is_action_pressed("ui_focus_prev"):
		prev_panel()

func _process(_delta):
	 #update position for drag function
	#max_frame = current_frame #figure out a way to get the max frames
	texture = comics_placeholder.get_sprite_frames()

	if can_drag == true: #my code
		drag()
		
	"""
	CONTROLS THE ANIMATED PLAYER NODE TO CYCLE THOUGH IMAGE
	It passes it's Debug to the Debug panel
	"""

		
	#sets the comic's placeholder to the current frame
	comics_placeholder.set_frame(int(current_frame))
	
	#Debug Variable
	if enabled:
		Debug.Comics_debug = str(
			'Current frame:', current_frame  , ' Max frames :' , max_frame, ' Texture: ',
			texture, enabled,'can drag: ',can_drag, ' target: ',target, 'touchpage:', Touch_page
			)

	"""
	ANIMATION PLAYER
	"""
	#rewrite with turnary statement 
	if enabled == true:
		show()
		animation.play("visible")
	else:
		#animation.play("slide_out")
		hide()
"""
DRAG FUNCTION
"""
func drag():  #Vector Maths
	#kinda works
	target = get_viewport().get_mouse_position()
	position = area2d.position
	center = restaVectores(target, position)
	if Touch_page == false:
		if abs(position.distance_to(target)) > 200: #if its far...
			##use suma vectores function for vector maths
			area2d.move_and_slide(center) #move and slide to center
			
			 #update position
			pass
		if abs(position.distance_to(target)) < 200 : #if its close
			area2d.move_and_slide(target) #move and slide to target
			
	if Touch_page == true: #if touching page set position to position
		area2d.set_position(target)

func next_panel():
	current_frame = current_frame + 1
	return int(current_frame) 


func prev_panel():
	current_frame =current_frame - 1 #fix this code
	return int(current_frame) 

func _on_Backwards_pressed():
	prev_panel()


func _on_Forward_pressed():
	next_panel()#fix this code


func next_chap():
	print ('next chapter') #replace with actual code
	#conditional
	if current_frame > max_frame: #Hopefully, this doesn't break 
		comics_placeholder = comics[2] #you can use memory[1] to change to next chapter 
		load_comics()

func prev_chap():
	print ('prev chapter') #duplicate code above


func guided_view(): #duplicate code above
	print('guided view')


func load_comics(): #pass a value to determine which comic gets loaded
	print ('loading new comics') 
	if memory.empty() == true: #error catcher 1
		current_comics = load(comics[1])
	if memory.empty() != true && current_comics == null: #error catcher 2
		current_comics = memory[0] #default comics
		#comics_placeholder = current_comics

	current_frame = 0
#reparent comics scene
	get_node('Area2D/placeholder').add_child(current_comics.instance())
	update_mem()
	comics_placeholder.set_frame(current_frame) #try and get the comic node, not the scene file
	comics_placeholder.position = Vector2(0,0)
	#comics_placeholder.set_flip_v(180) #corrects a flipping problem
	#set placeholder size with code
	
	#print (comics_placeholder.get_offset())
	current_frame  =int(comics_placeholder.get_frame())  #gets the current frame of the placeholder

func update_mem():
	memory=get_tree().get_nodes_in_group("comics") #retuns an array of all comics in the scene tree
	comics_placeholder = memory[0]

"""
DRAG AND DROP 
"""
#it requires you set mouse filter to ignore on all control nodes 
#so the area 2d can get mouse input data

#find a way to set the collision shape size to the size of the current frame
func _on_Area2D_mouse_entered():
	Touch_page = true
func _on_Area2D_mouse_exited():
	Touch_page = false 

func restaVectores(v1, v2): #vector substraction
	return Vector2(v1.x - v2.x, v1.y - v2.y)
	
func sumaVectores(v1, v2): #vector sum
	return Vector2(v1.x + v2.x, v1.y + v2.y)
