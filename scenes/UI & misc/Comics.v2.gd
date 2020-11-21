extends Control

# *************************************************
# godot3-Dystopia-game by INhumanity_arts
# Released under MIT License
# *************************************************
#
# This is a pluggin containing the comics logic
# information used by the comics placeholder codes.
#
# *************************************************

 #it has a wierd updatable bug that's visible in the debug panel

export (bool) var enabled 
signal loaded_comics 
signal freed_comics

export (PackedScene) var current_comics 

"""

"""
var comics = {
	 1: 'res://scenes/Comics/chapter 1/chapter 1.tscn',
	2:'res://scenes/Comics/chapter 2/chapter 2.tscn',
	3:'res://scenes/Comics/chapter 3/chapter 3.tscn'
}



var memory = {}

var  current_frame   = int (0)

var next_comic = null

var can_drag = false
onready var zoom = false
onready var comics_placeholder 

#onready var animation = $AnimationPlayer 
#onready var buttons
onready var Kinematic_2d  #the kinematic 2d node for drag and drop
#onready var camera2d = $Kinematic_2D/placeholder/Camera2D 
onready var position 
onready var center
onready var target =Vector2(0,0) #set position to the center of the viewport

onready var loaded_comics = false

#delete this code
#onready var Touch_debug = load ("res://New game code and features/Multitouch debug/Main.tscn")

func _enter_tree():
	if current_comics !=null:
		load_comics()
	pass




func _ready():
	enabled = false
	
	
	target = Vector2()
	

	


 
func load_comics(): 
	if current_comics != null && current_comics.can_instance() == true:
		for _p in get_tree().get_nodes_in_group('Cmx_Root'):
			enabled = true
			zoom = false

			current_frame =  int(0)
			Kinematic_2d = KinematicBody2D.new()
			comics_placeholder = Control.new()
		
			Kinematic_2d.name= 'Kinematic_2d'
			comics_placeholder.name = 'comics_placeholder'
	
			comics_placeholder.set_mouse_filter(2)

			_p.call_deferred('add_child',comics_placeholder) #reparents comic placeholder node 
			#get_tree().get_root().get_node(".").call_deferred('add_child',comics_placeholder)
			print ('Comic root:',_p)


			comics_placeholder.add_child(Kinematic_2d)
	
			var collision_shape =CollisionShape2D.new()
			var shape = RectangleShape2D.new() #new code
			shape.set_extents((Vector2(130,130))) #new code
			collision_shape.set_shape (shape) #new code
	
	
			Kinematic_2d.add_child(collision_shape) #set the collision shape
			#connect signals
			Kinematic_2d.connect("mouse_exited",self,'_on_Kinematic_2D_mouse_exited') 
			Kinematic_2d.connect('mouse_entered',self,'_on_Kinematic_2D_mouse_entered')
	
			print ('loading comics') 
			emit_signal("loaded_comics")
			Kinematic_2d.add_child(current_comics.instance()) 
 
	if current_comics == null and current_comics.can_instance() == false  :
		push_error('unable to instance comics scene')
		pass
	if memory.empty() != true && current_comics == null: #error catcher 1
		current_comics = memory[0] # load from memory

	if memory.empty() == true && current_comics == null: #error catcher 2
		push_error('current comics empty')
		current_comics = comics[1] #default comic


	loaded_comics = true
	comics_placeholder.show()




func _input(event): 
	#[ignore warning]
	#Comic panel changer

	if event.is_action_pressed("ui_focus_next") && enabled:
		next_panel()
	if event.is_action_pressed("ui_focus_prev") && enabled:
		prev_panel()


#Toggles comics visibility on/off
#It disappears if not enabled 
	if  enabled == false and event.is_action_pressed("comics") :
		enabled = true 
	elif enabled == true and event.is_action_pressed("comics") :
		enabled = false

#place all input events in here
	# Handle Touch
	if event is InputEventScreenTouch: #zoom if screentouch is 2 fingers
		if event.pressed && event.index == int(2):
			_zoom()
			pass




	# Handles ScreenDragging
	if event is InputEventScreenDrag:
		drag()
		pass
# Handles releasing 
		 

	#no code yet

# Handles double clicking
	#zoom in / zoom out

	if event is InputEventMouseButton && event.doubleclick && loaded_comics == true:
		_zoom()

	#if event is InputEventMouseButton && event.doubleclick : #zoom does not work
		#if zoom == true && loaded_comics == true:
			





func _process(_delta):

	if current_comics == null or current_frame == null  : #error catcher 
		emit_signal("freed_comics")
		loaded_comics = false
	if loaded_comics == true:
		emit_signal("loaded_comics")
	
	if enabled == true: #toggles visibility
		show()

	if enabled == false:
		hide()

	memory=get_tree().get_nodes_in_group("comics") #an array of all comics in the scene tree
	#print (OS.get_ticks_msec() )

	if memory.empty() != true :
		pass
	elif memory.empty() == true:
		#current_comics = load_comics()
		pass

	
	if loaded_comics == true && memory.size() >= 2: #double instancing error fix
		get_tree().queue_delete(memory.front()) 
		loaded_comics = false 


#current frame controler

	if enabled && Kinematic_2d != null:
		for _i in Kinematic_2d.get_children():
			if _i is AnimatedSprite:
				_i.set_frame(int(current_frame))  
				#working
				_i.update() #canvas layer not updating changes
				if  current_frame > _i.get_frame() : #Buggy add an m.tick timer for delay here
					comics_placeholder.queue_free()
					enabled = false #fixes a null instance bug
					loaded_comics = false #working buggy
					current_frame = null # working buggy

		#check if the node signals are connected


	if can_drag == true: 
		drag()

	#Debug Variable
	if enabled:
		Debug.Comics_debug = str(
			'Curr frme:', current_frame , 'Cmx: ',current_comics, 'Enbled',enabled,'can drag: ',can_drag,
			 ' Zoom: ',zoom, 'LC: ',loaded_comics
			)

	"""
	ANIMATION PLAYER
	"""

"""
DRAG FUNCTION
"""
func drag():  
	#improve this function #add more parameters
	target = get_viewport().get_mouse_position()
	position = Kinematic_2d.position
	center = restaVectores(target, position)
	Kinematic_2d.set_position(target)
	if abs(position.distance_to(target)) > 200: #if its far...
		##use suma vectores function for vector maths
		Kinematic_2d.move_and_slide(center) #move and slide to center

	if abs(position.distance_to(target)) < 200 : 
		Kinematic_2d.move_and_slide(target) 

	#if Touch_page == true: 
		#Kinematic_2d.set_position(target)

func _zoom():
	var scale =comics_placeholder.get_scale()
	if scale == Vector2(1,1)  :
		print ('zoom in')
		comics_placeholder.set_scale(scale * 1.5) 
		zoom = true 
	if scale > Vector2(1,1):
		print ('zoom out')
		scale = comics_placeholder.get_scale()
		comics_placeholder.set_scale(scale / 1.5) 
		zoom = false 


func next_panel():
	current_frame = current_frame + 1
	return int(current_frame) 


func prev_panel():
	current_frame =abs(current_frame - 1 )
	return int(current_frame) 

func _on_Backwards_pressed():
	prev_panel()


func _on_Forward_pressed():
	next_panel()


func next_chap():
	print ('next chapter') 


func prev_chap():
	print ('prev chapter') #duplicate code above






"""
DRAG AND DROP 
"""
#it requires you set mouse filter to ignore on all control nodes 
#so the area 2d can get mouse input data


func restaVectores(v1, v2): #vector substraction
	return Vector2(v1.x - v2.x, v1.y - v2.y)
	
func sumaVectores(v1, v2): #vector sum
	return Vector2(v1.x + v2.x, v1.y + v2.y)


func _on_Kinematic_2D_mouse_exited():
	print ('working 3')
	#these code blocs aren't working
	can_drag = false


func _on_Kinematic_2D_mouse_entered():
	print('working 2')
	#these code blocs aren't working
	can_drag = true




func _exit_tree(): #clear unused variables when exiting scene
	next_comic.free()
	pass


#rearrange this code

func _on_chap_1_pressed():
	print ('loading chap 1')
	#comics.current_comics = load(comics[1]) #try this instead of extending script
	current_comics = load(comics[1])
	load_comics() 

func _on_chap_2_pressed():
	print ('loading chap 2')
	#comics.current_comics = load(comics[2]) #try this instead of extending script
	current_comics = load(comics[2])
	load_comics() #for testing

func _on_chap_3_pressed():
	print ('loading chap 3')
	#comics.current_comics = load(comics[3]) #try this instead of extending script
	current_comics = load(comics[3])
	load_comics() #for testing

