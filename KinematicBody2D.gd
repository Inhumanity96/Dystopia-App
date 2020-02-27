extends KinematicBody2D
var next_scene= null

var destination = Vector2()
var gap = Vector2()
var speed = null

func _ready():
	speed =1300 
	
	destination = Vector2() + ( position)





func _process(delta):
	if position != destination:
		gap =( ( destination - position) + Vector2())
		move_and_slide(gap.normalized() * speed)
	if gap.abs() < Vector2(20,20):
		set_position(destination)
	elif position == destination:
		move_and_slide(gap * 0)
	
	



func _input(event):
		if Input.is_action_just_pressed("test keys (dev) left") : 
			if destination != Vector2() +  get_node("Position B").get_position() and destination !=  Vector2() +  get_node("Position C").get_position() and  destination !=  Vector2() +  get_node("Position A").get_position():
				destination =  Vector2() +  get_node("Position B").get_position()
			elif destination ==Vector2() +  get_node("Position B").get_position():
				destination =  Vector2() +  get_node("Position C").get_position()
			elif destination ==  Vector2() +  get_node("Position C").get_position() :
				destination =  Vector2() +  get_node("Position A").get_position()
			elif destination == Vector2() +  get_node("Position A").get_position()  :
				get_tree().change_scene_to(next_scene) 
			#you can move camera with pos A,B,C and when player is at pos c(the conditon above) switch to next scene
			move_and_slide(destination)
			
			
			
			
		 

	
		#
				#move_and_slide(destination)
				#print(destination)
				#print(get_node("Position C").get_position())
	#else : print("speed")
		
		
		#print(destination)
		#print(get_node("Position B").get_position())
		
	 
	
			
			
			
			
		
		
		

#this is for dervelopers only...delete it in the final app

func _on_TextureButton_pressed():
				if destination != Vector2() +  get_node("Position B").get_position() and destination !=  Vector2() +  get_node("Position C").get_position() and  destination !=  Vector2() +  get_node("Position A").get_position():
					destination =  Vector2() +  get_node("Position B").get_position()
				elif destination ==Vector2() +  get_node("Position B").get_position():
					destination =  Vector2() +  get_node("Position C").get_position()
				elif destination ==  Vector2() +  get_node("Position C").get_position() :
					destination =  Vector2() +  get_node("Position A").get_position()
				elif destination == Vector2() +  get_node("Position A").get_position()  :
					get_tree().change_scene_to(next_scene) 
			#you can move camera with pos A,B,C and when player is at pos c(the conditon above) switch to next scene
					move_and_slide(destination)


