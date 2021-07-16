extends CanvasLayer


func _ready():
	Dialogs.connect("dialog_started", self, "_on_dialog_started")
	Dialogs.connect("dialog_ended", self, "_on_dialog_ended")
	
	$Stats.connect("not_enabled",self, '_on_status_hidden')
	$Stats.connect('enabled',self,'_on_status_showing')
	$Comics.connect( 'freed_comics', self, '_on_comics_freed'  )
	$Comics.connect("showing_comics",self , 'on_comics_showing') #this line is buggy
	#connect comicss and comics button
	
	$"Menu ".connect("menu_hidden",self,'on_menu_hidden')
	$"Menu ".connect("menu_showing",self,'on_menu_showing')
	
func _on_dialog_started():
	#for child in get_children():
	#	child.hide()
	$TouchInterface.interract()
	#$interact.show()

func _on_dialog_ended():
	#for child in get_children():
	#	child.show()
	$TouchInterface.reset()



	#elif what == NOTIFICATION_UNPAUSED:
	#	for child in get_children():
	#		if child is Node2D :
	#				child.reset()
	#	
func _input(_event):
	if Input.is_action_just_pressed("comics"):
		if $Comics.enabled == true:
			if $TouchInterface.state != 'comics' and $Comics.loaded_comics == true:
				$TouchInterface.comics()
		elif $Comics.enabled == false or $Comics.loaded_comics == false:
			$TouchInterface.reset()
	if Input.is_action_just_pressed("pause"):
		if $Stats.enabled == true :
			$TouchInterface.status() #calls a display function int the touch interface scene
			
	if Input.is_action_just_pressed('menu'):
		if $"Menu ".enabled == true:
			$TouchInterface.menu()
		elif $"Menu ".enabled == false:
			$TouchInterface.reset()
	if Input.is_action_just_pressed('attack'):
		if $TouchInterface.state != 'attack':
			$TouchInterface.attack()
			yield(get_tree().create_timer(3.0), "timeout")
			$TouchInterface.reset()

func _on_comics_freed():
	$TouchInterface.reset()

func _on_status_showing():
	$TouchInterface.reset()
	print('status hidden') #for debug purposes

func _on_status_hidden():
	#$Stats.enabled = false
	$TouchInterface.status()
	print('status showing')

func on_comics_showing():
	$TouchInterface.comics()

func on_menu_showing():
	$TouchInterface.menu()
func on_menu_hidden():
	$TouchInterface.reset()
