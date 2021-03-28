extends Popup


"""
NOTIFICATION GENERIC BAR
"""
#add signals

export (bool)var condition 

func _ready():

	self.call_deferred('popup')
#	self.popup_centered()

func _exit_tree():
	self.queue_free()


#func _process(_delta): #add other functionalities to the notificatio bar
#	self.popup() if condition == true else pass
