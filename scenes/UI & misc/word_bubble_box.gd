extends AnimatedSprite

signal dialog_started
signal dialog_ended
func show_dialog(text, speaker):
	pass
var lines_to_skip = 0

func _ready():
	Dialogs.dialog_box = self
	hide()
	pass # Replace with function body.

#func show_dialog(new_text, speaker):
	#dialog_text.text = new_text
	#$nametag/label.text = speaker
	lines_to_skip = 0
	#dialog_text.lines_skipped = lines_to_skip
	#$anims.play("appear")
	#pass

func hide_dialogue(): #my code
	$anims.play("disappear")

func _input(event):
	if event.is_action_pressed("interact"): #change the action 
		match $anims.assigned_animation:
			"show_text": 
				$anims.play("wait")
			"wait":
				lines_to_skip += 2
				#if lines_to_skip < dialog_text.get_line_count(): 
				#	dialog_text.lines_skipped = lines_to_skip
				#	$anims.play("show_text")
				#else:
				#	$anims.play("disappear")
