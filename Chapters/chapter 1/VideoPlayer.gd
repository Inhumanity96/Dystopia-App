extends VideoPlayer


func _ready():
	OS.native_video_play('res://Chapters/chapter 1/intro.ogv', 1,'res://Resources/sounds/intro.ogg','')
	print ('playing')
#this code is to tell the os to play this video 


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
