extends Control


"""
COMICS PLACEHOLDER CODE. IT INHERITS FROM A CONTROL NODE

"""

#It comtains code to get several properties from the comic's placeholder 
#node and control them

#gets the Sprite node and gets several properties from the sprite node

onready var current_frame  
onready var hframe 
onready var vframe
onready var texture
var next_scene = null
var max_frame = 4

#Set signal that emits when the comics is visible
#signal comics_showing 
#signal comics_not_showing
onready var comics_placeholder= $placeholder #The comics placeholder sprite
onready var comics = self
onready var slide_in_animation = $AnimationPlayer

#Returns true / false if the comics placeholder sprite is showing
var is_comics_showing 


func _ready():
	
	comics.hide()     #.show() #use .hide()
	current_frame  = comics_placeholder.get_frame() #gets the cuttent frame of the placeholder
	hframe =comics_placeholder.get_hframes() #gets the hframe count of the spritesheet
	vframe = comics_placeholder.get_vframes()
	
	
	#gets the current texture in the placeholder. Saves it to a variable
	#write code to cycle through spritesheets in a global variable
	texture =  comics_placeholder.get_texture()
	
	

func _process(_delta):
	"""
	CONTROLS THE ANIMATED PLAYER NODE TO CYCLE THOUGH IMAGE
	update code to account for comics hframes and v frames
	and to adapt accordingly
	"""
	#Checks if the Comics placeholder is visible and saves it as a boolean
	is_comics_showing = null #comics_placeholder.is_pixel_opaque()
	
	
	Debug.Comics_debug = str( current_frame, hframe, vframe, texture, is_comics_showing)
	#moves the current image frame forward
	#current_frame = current_frame + 1
	#set_frame(current_frame)
	if current_frame == max_frame :
		get_tree().change_scene_to(next_scene)
		queue_free() 
	
	#moves the current image frame backwards
	#current_frame = current_frame - 1
	#set_frame(current_frame)


	"""
	FUNCTION THE COMICS PANEL TO THE NEXT PANEL, PREVIOUS PANEL AND THE NEXT CHAPTER
	it also loads the next chapter if its available and locks unavailable chapters
	"""

func _comics(): #replace with actual code
	print('any other miscellaneous codes you forgot to add')

func next_panel():
	print ('next panel') #replace with actual code
	pass

func prev_panel():
	print ('previous panel') #replace with actual code
	pass

func next_chap():
	print ('next chapter') #replace with actual code

func prev_chap():
	print ('prev chapter') #replace with actual code


func guided_view(): #replace with actual code
	print('guided view')


func load_comics():
	print ('loading new comics') ##replace with actual code
	#run as a loop



"""
Checks if the comic is visible and plays the appropriate animation
"""


func _on_comics_button_pressed():
	if true :  #and is_comics_showing == false #this was a second condition to call the comics placeholder code to
		comics.show()
		slide_in_animation.play("slide_in")
		#emit_signal("comics_showing")
		pass
	else:
		comics.hide()
		slide_in_animation.play("slide_out")
		#emit_signal("comics_not_showing") #get rid of this code only emit one signal from this code
	pass
# this code closes the comics placeholder when touched or clicked











func _on_Backwards_pressed():
	prev_panel()


func _on_Forward_pressed():
	next_panel()
