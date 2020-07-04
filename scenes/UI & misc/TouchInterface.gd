extends Node2D

var Touch_interface = self

func _ready():
	Dialogs.connect("dialog_started", self, "_on_dialog_started")
	Dialogs.connect("dialog_ended", self, "_on_dialog_ended")
	pass # Replace with function body.

func _on_dialog_started():
	for child in get_children():
		child.hide()
	$interact.show()

func _on_dialog_ended():
	for child in get_children():
		child.show()


func _notification(what):
	if what == NOTIFICATION_PAUSED:
		for child in get_children():
			child.hide()
		$stats.show()
	elif what == NOTIFICATION_UNPAUSED:
		for child in get_children():
			child.show()




func _on_Comics_comics_showing():
	 Touch_interface.hide() 


func _on_Comics_comics_not_showing():
	Touch_interface.show()