extends Node

const DEFAULT_PORT = 10567
# Max number of players.
const MAX_PEERS = 12

#Is a NetworkedMultiplayerENet: Is what is 
var peer: NetworkedMultiplayerENet = null

var players = {}
var player_name = "yo mama"
var players_ready = []
var ip = "127.0.0.1"


#LOBBY SIGNALS
signal player_list_changed()
signal connection_failed()
signal connection_succeeded()
signal show_lobby()
signal message_received(id, message)
signal server_closed()
signal game_ended()
signal game_error(what)

func _ready():
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_on_player_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_ok")
	get_tree().connect("connection_failed", self, "_on_connected_fail")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")
	
	
	var upnp = UPNP.new()
	if(upnp.discover() == 0):
		if(upnp.add_port_mapping(DEFAULT_PORT) == 0):
			ip = upnp.query_external_address()
		else:
			print("UPNP connection failed. Use private IP as IP.")
	else:
		print("UPNP connection failed. Use private IP as IP.")
	

func host_game(new_player_name):
	player_name = new_player_name
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PEERS)
	get_tree().set_network_peer(peer)
	emit_signal("show_lobby")

func join_game(ip, new_player_name):
	player_name = new_player_name
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(peer)
	emit_signal("show_lobby")
	
# This is called on all clients (even listen server) whenever someone connects
func _on_player_connected(id):
	rpc_id(id, "register_player", player_name)
	
remote func register_player(new_player_name):
	print("Registering player " + new_player_name)
	var id = get_tree().get_rpc_sender_id()
	players[id] = {"Name" : new_player_name, "Ready" : false} 
	emit_signal("player_list_changed")
		
func _on_connected_ok():
	emit_signal("connection_succeeded")
	
func _on_player_disconnected(id):
	unregister_player(id)
	
func unregister_player(id):
	if players.has(id):
		players.erase(id)
	emit_signal("player_list_changed")
	
func _on_connected_fail():
	emit_signal("connection_failed")
	
func _on_server_disconnected():
	players.clear()
	emit_signal("server_closed")

func get_player_list():
	return players.values()
	
func change_player_ready():
	rpc("player_readied")

remote func player_readied():
	var id = get_tree().get_rpc_sender_id()
	players[id].Ready = !players[id].Ready
	emit_signal("player_list_changed")
	

func send_message(message):
	rpc("send_message_all", message)
	
remote func send_message_all(message):
	var id = get_tree().get_rpc_sender_id()
	emit_signal("message_received", id, message)








#############################
## STARTING GAME FUNCTIONS ##
#############################

func start_game():
		
	print(players)
	
	#Assert means that if this client is not the host --> Stop the code
	#This means only the host should be running this code (This is a SERVER ONLY COMMAND)
	assert(get_tree().is_network_server())
	
	#Signal other plays to start pre-game code
	rpc("pre_start_game")


#Run after start button is pressed but before it actually starts
remotesync func pre_start_game():

	# Change to game scene while keeping lobby scene loading
	var Game = load("res://Game.tscn").instance()
	get_tree().get_root().add_child(Game)
	get_tree().get_root().get_node("Menus").hide()
	
	# Add this clients player to the game scene
	var my_player = load("res://Player.tscn").instance()
	my_player.set_name(str(get_tree().get_network_unique_id()))
	my_player.set_in_game_name(player_name)
	my_player.set_network_master(get_tree().get_network_unique_id())
	get_node("/root/Game").add_child(my_player)
	
	# Add all other players to the game scene
	for p in players:
		var player = load("res://Player.tscn").instance()
		player.set_name(str(p))
		player.set_network_master(p)
		player.set_in_game_name(players[p].Name)
		get_node("/root/Game").add_child(player) 
		get_node("/root/Game/" + str(p)).position += Vector2(100, 0)
	
	#If NOT THE SERVER HOST --> Tell server we are ready
	if not get_tree().is_network_server():
		# Tell server we are ready to start.
		rpc_id(1, "ready_to_start", get_tree().get_network_unique_id())
	
	#If you are the only player in the lobby, just start post-start-code
	elif players.size() == 0:
		post_start_game()

remote func post_start_game():
	get_tree().set_pause(false) # Unpause and unleash the game!

remote func ready_to_start(id):
	#Makes sure only server is receiving this message
	#This is more for catching errors (THIS SHOULDN'T HAPPEN BUT IF IT DOES IT GETS CAUGHT)
	assert(get_tree().is_network_server())
	
	#The the client that sent this signal is not already ready, ready them up
	if not id in players_ready:
		players_ready.append(id)

	#If all the players are ready
	if players_ready.size() == players.size():
		#Start final start code for all clients
		for p in players:
			rpc_id(p, "post_start_game")
		#Start final start code for YOU (SERVER)
		post_start_game()
		
		
		
		
