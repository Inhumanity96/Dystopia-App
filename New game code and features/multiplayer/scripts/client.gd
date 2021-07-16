# *************************************************
# Based on code by godot3-spacegame by Yanick Bourbeau
# Released under MIT License
# *************************************************
# CLIENT-SIDE CODE
#
# All the client logics in one file!
# *************************************************
extends Node
var debug 

var my_info = { name = "Player" }
var preload_player = preload("res://scenes/characters/Player.tscn")
var preload_projectile = preload("res://New game code and features/multiplayer/scenes/projectile.tscn") #tweak
var preload_damage  #= preload("res://New game code and features/multiplayer/scenes/effects/damage.tscn") #tweak
var preload_explosion #= preload("res://New game code and features/multiplayer/scenes/effects/explosion.tscn") #tweak
var pos = Vector2(0,0)
var killcount = Globals.kill_count
# Player info, associate ID to data
var player_info = {}
#var projectiles = []
var my_peer = null
var last_update = -1 #probably used for updating the network
onready var node_players = Node.new()#$players #p2p player nodes
onready var node_enemies=Node.new()  #= #= $camera/projectiles #rewrote progectile nodes to enemy nodes
onready var camera = Camera2D.new()#$Camera2D#get_tree().get_root()
onready var progress_health = load('res://scenes/UI & misc/Healthbar.tscn')
onready var chat = $UI/item_chat

onready var state #im trying to send player state using rpc call and update it on the server using a remote funtion
func _ready():
	
	#Networking.add_child(self)
	node_enemies.name = 'node_enemies'
	node_players.name = 'node_players'
	self.add_child(node_players)
	self.add_child(node_enemies)
	
	
	
	print("Server IP       : " + Networking.cfg_server_ip)
	print("Player Name     : " + Networking.cfg_player_name)
	print("Spaceship Color : " + Networking.cfg_color)
	
	print("Connecting to server ...")
	
	var peer = NetworkedMultiplayerENet.new()
	
	# Create a client using specified server ip
	peer.create_client(Networking.cfg_server_ip, Networking.SERVER_PORT)
	
	# Associate the current network peer to the tree
	get_tree().set_network_peer(peer)
	
	# Keep the current peer somewhere to differenciate between you and other players
	my_peer = peer
	
	# Connect signals
	if get_tree().connect("connected_to_server", self, "client_connected_ok") != OK:
		print("Unable to connect signal (connected_to_server) !")
		
	if get_tree().connect("connection_failed", self, "client_connected_fail") != OK:
		print("Unable to connect signal (connection_failed) !")
		
	if get_tree().connect("server_disconnected", self, "server_disconnected") != OK:
		print("Unable to connect signal (server_disconnected) !")
	
	# Add a message to the chat box
	add_chat("Welcome to this network test!")
	add_chat("Connecting to server ....")
	
func _process(_delta):
	
	# To mitigate latency issues we use interpolation. The idea is simple, we receive
	# position updates every TICK_DURATION (50 ms, 20 per seconds). We interpolate between
	# the last two previous updates, this way we always have smooth movements. The
	# main drawback is added latency (100 ms).
	
	var target_timestamp = OS.get_ticks_msec() - (Networking.TICK_DURATION*2)
	



	# Adjust camera on position
	var peer_id = get_tree().get_network_unique_id()
	if player_info.has(peer_id): #if player if has a peer id, position.x is player_info[peer_id] position
		pos.x = player_info[peer_id].node.position.x
		pos.y = player_info[peer_id].node.position.y #updates vvarible with player's position
		#state = player_info[peer_id].node.state 
		#player_info[peer_id].pos = pos #im trying to add player position to player info
		#print('player info has id', 'Client pos', pos)
		#pass pos as a variable to server
		pass
	#camera.set_offset(pos)

	# Handle input (keyboard)
	handle_input()
		

func handle_input():
	
	# If not connected, don't handle input.
	if not my_peer.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
		return
		
	# if not currently playing, don't handle input too.
	if my_info == null:
		return
		
	# Send input events over network to the server
	
	# Move left
	if Input.is_action_just_pressed("move_left"): #sends player input to the server
		rpc_id(1,"player_input",get_tree().get_network_unique_id(),"left",true) #add player state change 
		#rpc_id(peer_id,'set_state',ger)
		#send player state
		#send player position
	if Input.is_action_just_released("move_left"):
		rpc_id(1,"player_input",get_tree().get_network_unique_id(),"left",false)
		
	# Move right
	if Input.is_action_just_pressed("move_right"):
		rpc_id(1,"player_input",get_tree().get_network_unique_id(),"right",true)
	if Input.is_action_just_released("move_right"):
		rpc_id(1,"player_input",get_tree().get_network_unique_id(),"right",false)
		
	# Handle moving forward
	if Input.is_action_just_pressed("move_up"):
		rpc_id(1,"player_input",get_tree().get_network_unique_id(),"up",true) #sends player input on the network with the player input funtion
	if Input.is_action_just_released("move_up"):
		rpc_id(1,"player_input",get_tree().get_network_unique_id(),"up",false)
		
	# Handle moving backward
	if Input.is_action_just_pressed("move_down"):
		rpc_id(1,"player_input",get_tree().get_network_unique_id(),"down",true)
	if Input.is_action_just_released("move_down"):
		rpc_id(1,"player_input",get_tree().get_network_unique_id(),"down",false)
		
	# Handle player attacking
	if Input.is_action_just_pressed("attack"): #sends these input to the server's logic
		rpc_id(1,"player_input",get_tree().get_network_unique_id(),"attack",true) #doesn't work
	if Input.is_action_just_released("attack"):
		rpc_id(1,"player_input",get_tree().get_network_unique_id(),"attack",false)
	#Handles player rolling #my code
	if Input.is_action_just_pressed("roll"):
		rpc_id(1,"player_input",get_tree().get_network_unique_id(),"roll",true)#doesn't work
	if Input.is_action_just_released("roll"):
		rpc_id(1,"player_input",get_tree().get_network_unique_id(),"roll",false) #doesn't work




		
func client_connected_ok():
	push_error("Callback: client_connected_ok")
	add_chat("Connected. Enjoy!")
	# Only called on clients, not server. Send my ID and info to all the other peers
	my_info.name = Networking.cfg_player_name
	my_info.color = Networking.cfg_color
	rpc_id(1,"register_player", get_tree().get_network_unique_id(), my_info)
	OS.set_window_title("Connected as " + my_info.name)

#####Add your codes here
	#rpc_id(1)


func  server_disconnected(): #tweak to 'sever diconnected, change scene to login
	push_error("Callback: server_disconnected")
	OS.alert('You have been disconnected!', 'Connection Closed')
	# Change to login scene
	get_tree().change_scene("res://scenes/login.tscn")
	if get_tree().change_scene("res://scenes/login.tscn") != OK:
		push_error("Unable to load login scene!")

func client_connected_fail():
	push_error("Callback: client_connected_fail")
	OS.alert('Unable to connect to server!', 'Connection Failed')
	# Change to login scene
	get_tree().change_scene("res://scenes/login.tscn")
	if get_tree().change_scene("res://scenes/login.tscn") != OK:
		push_error("Unable to load login scene!")
	
remote func player_joined(id, info): #tweak code###########################
	print("Callback: player_joined(" + str(id)+"," + str(info) + ")")
	player_info[id] = info
	add_chat("Player joined: " + player_info[id].name)
	
	var node_player = preload_player.instance()


	
	info.node = node_player #player node 
	info.updates = {}
	
	var pos = Vector2(info.position.x,info.position.y)
	#node_player.mode #= RigidBody2D.MODE_KINEMATIC
	node_player.set_position(pos)
	node_player.name = info.name
		
	node_players.add_child(node_player)
	

remote func player_respawned(id, info):
	print("Callback: player_respawned (" + str(id)+"," + str(info) + ")")
	player_info[id] = info
	add_chat("Player respawned: " + player_info[id].name)
	
	var node_player = preload_player.instance()
	var color = info.color.to_lower()
	
	#node_player.get_node("texture_player").texture = load("res://images/player_" + color + ".png")
	
	info.node = node_player
	info.updates = {}
	
	var pos = Vector2(info.position.x,info.position.y)
	#node_player.mode = RigidBody2D.MODE_KINEMATIC
	node_player.set_position(pos)
	node_player.name = info.name
	
	#node_players.append(node_player)
	node_players.add_child(node_player)
	
remote func player_leaving(id):
	print("Callback: player_leaving(" + str(id)+")")
	add_chat("Player leaving: " + player_info[id].name)
	player_info[id].node.queue_free()
	
	player_info.erase(id)

#updates players healths

remote func player_health(id, hitpoint): #where is this funtion called? 
	print("Callback: player_health(" + str(id) +","+str(hitpoint)+")")  #update this code to use player state
	if hitpoint == 0:
		player_info[id].destroyed = true
		add_chat(player_info[id].name +" destroyed!")
		player_info[id].node.queue_free()
		
	var peer_id = get_tree().get_network_unique_id()
	if id == peer_id:
		progress_health.value = hitpoint #updates the progress bar to player life
	
# Player update function
# This function is named "pu" to lower the network bandwidth usage, sending something
# like "player_update" will use an extra 220 bytes / second for each connected player. 
remote func pu(id, update_id, pos, hitpoints, rotation): #try and use killcounts
	
	# Unreliable packets can be sent in wrong order, we only work with the latest
	# data available.
	if update_id < last_update:
		print("Received update in wrong order. Discarding!")
		return
		
	last_update = update_id
	player_info[id].updates[OS.get_ticks_msec()] = { position = pos, hitpoints = hitpoints, killcount = killcount }
	while len(player_info[id].updates) > 10:
		player_info[id].updates.erase(player_info[id].updates.keys()[0]) #when length of player update is more than 10, erase some update data
	
	if player_info[id].destroyed: #if player is destroyed
		return
		
	
remote func attack(id, position, facing): #update code to be an attack #inhumanity
	#projectiles.append({ timestamp = OS.get_ticks_msec() + (Networking.TICK_DURATION * 2), id = id, position = position, current_angle = current_angle })
	#The original vode ran mainly using simulaions so
	#This was one of such simulations
	
	
	print('attack',id,position, facing)
	

func add_chat(text): #used the ui grid  
	#fix this function
	#print (text) #breaks here. returns nill
	#if chat.get_item_count() == 7:
	#	chat.remove_item(0)
	print('Add chat text: ',text)

	#for i in range(0,chat.get_item_count()): #iterate over chat item
	#	chat.set_item_selectable(i,false)
	
func display_damage(body): #not needed #rewrite this to instance blood fx
	#for peer_id in player_info:
	#	if player_info[peer_id].node == body:
	#		var node_damage = preload_damage.instance()
	#		node_damage.name = "damage"
	#		node_damage.get_node("particles").emitting = true
	#		node_damage.get_node("particles").one_shot = true
	#		player_info[peer_id].node.add_child(node_damage)
	#		break
	print ('damage: ' , body)
	
