extends TextureButton


#Add code here
#connect to online api
#get a variable called total like numbers
# map it to inspector

export(int) var no_of_likes #Get this vatiabe from the networking singleton

func _ready():
	like()


func _input(event):
	event = self
	#print( event.get_action_mode()) #== 'pressed':
	if event.is_pressed() == true :
		no_of_likes +=1 
		like()

#rewrite and update this
func like():
	$Label.set_text(str(no_of_likes))  
