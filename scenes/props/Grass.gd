extends Area2D


func _ready():
	$AnimationPlayer.play("normal",-1,1.0,0.0)
	connect("body_entered", self, "_on_grass_area_entered")
	#var sfx = load (Music.grass_sfx[0])
	pass

func _on_grass_area_entered(area):
	if area.name == "player_sword" :
		#play animation here
		destroy()
		print (str(area.name)+' cuts bush')
	if area.name == "enemy_sword" :
		
		destroy()
		print (str(area.name)+' cuts bush')
		
	else:
		pass
	
func destroy():
	#Music.play_track()
	#$stream.play(0.0)
	#self.hide()
	
	$AnimationPlayer.play("destroy")
	yield(get_tree().create_timer(0.3), "timeout")
	self.queue_free()
