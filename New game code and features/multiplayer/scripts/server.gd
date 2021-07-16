# *************************************************
# godot3-dystopia by Inhumanity_arts
# Released under MIT License
# *************************************************
# SERVER-SIDE CODE
#
# All the server  logics in one file!
#it also contains the worls logics *inhumanity
# *************************************************
extends Node

#my code
var player = {}

export (int) var state
var debug
#onready var Networking = GDScript.new()
#try and instance the outside scene and add a player

# Player info, associate ID to data
var player_info = {}

var delta_update = 0
var delta_interval = float(Networking.TICK_DURATION) * 0.001
#onready var server_camera = Camera2D.new()
onready var node_players = Node.new()#$Player
onready var node_projectiles #= $camera/projectiles #not needed
onready var node_enemies  = Node.new()#$Enemies

#.pop_front()

var preload_player = preload("res://scenes/characters/Player.tscn")
var preload_enemy = preload("res://scenes/characters/Enemy.tscn")
#var velocity_speed = 500
#var trust_origin = Vector2(0,0)
#var rotate_origin1 = Vector2(0,64)
#var rotate_origin2 = Vector2(0,-64)
#var rotation_power = 10.0
#var current_zoom = Vector2(20,20)
var update_id = 0

######for controling state machine
#var state
#enum { STATE_BLOCKED, STATE_IDLE, STATE_WALKING, STATE_ATTACK, STATE_ROLL, STATE_DIE, STATE_HURT }

func _ready():
	
	node_enemies.name = 'node_enemies'
	node_players.name = 'node_players'
	self.add_child(node_players)
	self.add_child(node_enemies)

	
	
	
	#print('Networking Camera: ' ,Networking.camera, 'Server Camera: ', server_camera) #for debug purposes only
	#print ('Networking world: ', Networking.world , 'Online world', self)
	
	print("Starting the server ...")
	print("Server port: " + str(Networking.SERVER_PORT))
	print("Max players: " + str(Networking.MAX_PLAYERS))
	var peer = NetworkedMultiplayerENet.new()
	print("Listening on port: " + str(Networking.SERVER_PORT))
	if peer.create_server(Networking.SERVER_PORT, Networking.MAX_PLAYERS) != OK:
		print("Unable to create server")
		return
		
	if get_tree().set_network_peer(peer) != OK:
		print("Unable to set network peer!")
	
	# Connect the signals
	if get_tree().connect("network_peer_connected", self, "player_connected") != OK:
		print("Unable to connect signal (network_peer_connected) !")
		
	if get_tree().connect("network_peer_disconnected", self, "player_disconnected") != OK:
		print("Unable to connect signal (network_peer_disconnected) !")


func _input(_event):
	#handle_input()
	pass

func _process(delta):
	#print(player_info, state) #for debug purposes only

	#camera.set_zoom(current_zoom) #sets the server's zoom to an unknown variable #fix this
	#print (state) #for debug purposes only. check to see if it sends player state
	for peer_id in player_info: #iterates over player info
		#print ('Server Pos',player_info[peer_id].pos)
	
	
		if player_info[peer_id].respawn_time != -999:
			player_info[peer_id].respawn_time -= delta
			if player_info[peer_id].respawn_time <= 0:
				
				player_info[peer_id].position = get_spawn_position()  #when first instanced to the scene
				#player_info[peer_id].velocity = 0
				#player_info[peer_id].rotation = 0
				#player_info[peer_id].firing = 0
				#player_info[peer_id].firing_delta = 0
				#player_info[peer_id].current_angle = 0
				player_info[peer_id].hitpoints = 3
				player_info[peer_id].respawn_time = -999
				player_info[peer_id].destroyed = false
				
				var node_player = preload_player.instance()
				print ('player instanced')
				player_info[peer_id].node = node_player
			
				var pos = Vector2(player_info[peer_id].position.x,player_info[peer_id].position.y)
				
				node_player.set_position(pos)
				node_player.show()
				node_player.set_process(true)
				
				node_player.name = player_info[peer_id].name #set name to player's name
				
				node_players.add_child(node_player)
				
				node_players.add_child(player_info[peer_id].node) #my code
				
				# Broadcast the new player to everyone
				for peer_id2 in player_info:
					rpc_id(peer_id2, "player_respawned", peer_id, player_info[peer_id])

	
func _physics_process(delta):
	#controls the playr's movements
	for peer_id in player_info: #player_info[peer_id].node is the player node. player_info stores player information
		Networking.multiplayer_debug = (str(" / "+ str('Hitpoints') + str(player_info[peer_id].node.hitpoints)) + " / " + str ('Node pos: ')+ str(player_info[peer_id].node.position) + " / " +str ('Player state:')+ str(player_info[peer_id].state))
		Networking.multiplayer_debug_2 = ("Player id:" + str(peer_id) + " = " + str ('peer id pos: ') + str(player_info[peer_id].position) + " = " + str(player_info[peer_id].node.facing)) #maps remote player debug to debug variable
		if player_info[peer_id].destroyed: #rewrite to use despawned #add destroyed variable to the player script
			continue
		
		var v = Vector2(0,0) #not needed
		if player_info[peer_id].node != null: #pass information from the player nodes
			state =player_info[peer_id].node.state
		if player_info[peer_id].node.hitpoints == 0: #if playerhas no life
			player_info[peer_id].node.despawn()
			print('yebaayebaa__samboribobo- server') #This is where the main code's logic are

		v = player_info[peer_id].node.get_position()
		
		# Keep the player within boundaries
		var world_radius = Networking.WORLD_SIZE / 2
		if v.x > world_radius:
			v.x = world_radius
			player_info[peer_id].node.set_position(v)
		if v.x < -world_radius:
			v.x = -world_radius
			player_info[peer_id].node.set_position(v)
		if v.y > world_radius:
			v.y = world_radius
			player_info[peer_id].node.set_position(v)
		if v.y < -world_radius:
			v.y = -world_radius
			player_info[peer_id].node.set_position(v)
		
		#sets each player's attribute to itself sent over the network
		var __pos =player_info[peer_id].node.get_position()
		
		player_info[peer_id].node.set_position(__pos)
		
	
	delta_update += delta
	while delta_update >= delta_interval:
		delta_update -= delta_interval
		broadcast_world_positions()
	
func broadcast_world_positions():
	
	for peer_id in player_info:
		for peer_id_2 in player_info:
			rpc_unreliable_id(peer_id, "pu", peer_id_2, update_id, player_info[peer_id_2].position, player_info[peer_id_2].hitpoints, player_info[peer_id_2].state)
			
	update_id += 1
	
	
func player_connected(id):
	print("Callback: server_player_connected: " + str(id))
	OS.set_window_title("Connected as " + str('server'))

func player_disconnected(id):
	print("Callback: server_player_disconnected: " + str(id))
	
	# Broadcast the "player_left" message to every other players
	for peer_id in player_info:
		rpc_id(peer_id, "player_leaving", id)

	# Erase player from player information array
	player_info[id].node.queue_free()
	player_info.erase(id) 
	
##note player_info[id] is how to call players

func get_spawn_position():
	
	var pos = Vector2(0,0)
	pos.x = rand_range(-950,950)
	pos.y = rand_range(-950,950)
	return pos


# Register a new player
remote func register_player(id, info): #rewrite this
	print("Remote: register_player(" + str(id) +","+str(info)+")")


##################################Gets information from player when first enters world#####################################
	info.position = get_spawn_position()  #calls a random spawnpoint in the world
	#info.linear_vel = Player.linear_vel #this line breaks
	#info.rotation = 0
	info.poss =Vector2()  #edit this
	info.killcount = Globals.kill_count
	info.state = Globals._player_state if Globals.player != null else 1
	info.hitpoints = 3
	info.respawn_time = -999
	info.destroyed = false
#####################################################################################################
	# send list of previous players to the new one
	for peer_id in player_info:
		rpc_id(id, "player_joined", peer_id, player_info[peer_id])
	
	
	var node_player = preload_player.instance()
	info.node = node_player

	var pos = Vector2(info.position.x,info.position.y) #position is player into position
	
	node_player.set_position(pos)
	node_player.show()
	node_player.set_process(true)
	
	node_player.name = info.name
	
	node_players.add_child(node_player) #adds child to the scene as a child of node-players
	
	# Store the information
	player_info[id] = info
	
	# Broadcast the new player to everyone
	for peer_id in player_info:
		rpc_id(peer_id, "player_joined", id, player_info[id])



remote func player_input(id, key, pressed): # #it receives player input from rpc
	print("Remote: player_input(" + str(id)+","+key+","+str(pressed)+")")

	if key == "left": #sets player info from remote input
		player_info[id].node.facing = 'left'#rotation = -1 if pressed else 0
	if pressed == true:
		#Globals.player.state = player_info[id].node.state 
		player_info[id].node.state = 2
		print ('statechanger test a',player_info[id].node.state, player_info[id].node.position )
	if  pressed == false: #it changes state but not position
		player_info[id].node.state = 1
		print ('statechanger test b',player_info[id].node.state, player_info[id].node.position) #for debug purposes only
	elif key == "right":
		player_info[id].node.facing = 'right'#rotation = 1 if pressed else 0
	
	elif key == "up":
		player_info[id].node.facing = 'up'#.velocity = -1 if pressed else 0
	
	elif key == "down":
		player_info[id].node.facing ='down'#velocity = 1 if pressed else 0
	#if pressed :
		 #2 is state walking 
	#if not pressed :
		#player_info[id].node.state = 1 #1 is state idle
		#break
	
	
	
	
	#elif key == "fire": #replace with other functions/ keys
	#	player_info[id].firing = 1 if pressed else 0
		
		
remote func state_test(id,key,pressed): #modify code *inhumanity
	print("Remote: function_state changer("+ str(id)+","+key+","+str(pressed)+")")
	if key == "attack":
		player_info[id].node.state = 3 #if pressed else player_info[id].node.state = STATE_IDLE
	if key == "roll":
		player_info[id].node.state = 4




	
	
	#get rid of extra variables in the networking.gd

	pass
func player_got_shot(body): #tweak code #add shooting mechanics to gameplay
	print("player got shot!")
	for peer_id in player_info:
		if player_info[peer_id].node == body:
			if not player_info[peer_id].health == 0:
				player_info[peer_id].health -= 10
				if player_info[peer_id].health < 0:
					player_info[peer_id].health = 0
					
				# broadcast!
				print("Broadcast health: " + str(player_info[peer_id].health))
				for peer_id2 in player_info:
						rpc_id(peer_id2, "player_health", peer_id, player_info[peer_id].health)
						
				if player_info[peer_id].health == 0:
					player_info[peer_id].destroyed = true
					player_info[peer_id].respawn_time = 5.0
					player_info[peer_id].node.queue_free()
					


