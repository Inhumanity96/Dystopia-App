extends Area2D

func _ready():
	connect("body_entered", self, "_on_grass_area_entered")
	pass

func _on_grass_area_entered(area):
	if area.name == "player_sword":
		#play animation here
		self.queue_free()
	pass # Replace with function body.
