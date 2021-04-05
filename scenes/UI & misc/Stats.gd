extends PanelContainer

var enabled = false


	
func _ready():
	Globals.save_game()
	get_tree().set_auto_accept_quit(false)
	hide()

func _input(event):
	if event.is_action_pressed("pause"):
		enabled = !enabled
		visible = enabled
		get_tree().paused = enabled
		if enabled:
			grab_focus()
			_update_quest_listing()
			_update_item_listing()
			_update_killcount()
			

func _update_killcount():
	$VBoxContainer/HBoxContainer/Inventory/Kill_count.text = 'killcount: '+str (Globals.kill_count)


func _update_quest_listing():
	var text = ""
	text += "Started:\n"
	for quest in Quest.list(Quest.STATUS.STARTED):
		text += "  %s\n" % quest
	text += "Failed:\n"
	for quest in Quest.list(Quest.STATUS.FAILED):
		text += "  %s\n" % quest
	
	$VBoxContainer/HBoxContainer/Quests/Details.text = text
	pass

func _update_item_listing():
	var text = ""
	var inventory = Inventory.list()
	if inventory.empty():
		text += "[Empty]"
	for item in inventory:
		text += "%s x %s\n" % [item, inventory[item]]
	$VBoxContainer/HBoxContainer/Inventory/Details.text = text
	pass



func _on_Exit_pressed():
	quit_game()
	pass # Replace with function body.

func _notification(what):  #i removed this notification functioncode from the game cuz i don't know what it does yet
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		quit_game()
		pass
func quit_game():
	Globals.save_game()
	get_tree().quit()
