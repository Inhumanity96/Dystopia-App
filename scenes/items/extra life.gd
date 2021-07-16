extends Area2D



"""
EXTRA LIFE
"""

export(String) var item_type = "Extra Life"
export(int) var amount = 1

func _ready():
	connect("body_entered", self, "_on_Item_body_entered")
	pass

func _on_Item_body_entered(body):
	if body is Player:
		call_deferred("disconnect", "body_entered", self, "_on_Item_body_entered")
		#Inventory.add_item(item_type, amount)
		body.hitpoints += 1
		$anims.play("collected")
		body.emit_signal("health_changed", body.hitpoints)
		yield(get_tree().create_timer(0.8), "timeout")
		$pickup.stop()
	pass
