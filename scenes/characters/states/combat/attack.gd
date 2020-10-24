extends 'res://scenes/characters/State Machine.gd'

func enter():
	owner.get_node("AnimationPlayer").play("idle")


func _on_Sword_attack_finished():
	emit_signal("finished", "previous")
