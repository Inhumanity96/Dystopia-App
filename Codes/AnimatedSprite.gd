extends AnimatedSprite

var current_frame = self.get_frame()
var next_scene = load ("res://scenes/levels/Menu.tscn")
var max_frame = 4
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




#this code changes the current frame whenever the buttons are pressed

func _on_forward_pressed():
	current_frame = current_frame + 1
	set_frame(current_frame)
	if current_frame == max_frame :
		get_tree().change_scene_to(next_scene)
		queue_free() ; next_scene = null
	




func _on_backwards_pressed():
	current_frame = current_frame - 1
	set_frame(current_frame)










	
