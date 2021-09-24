extends Node

const DEFAULT_PORT = 10567
# Max number of players.
const MAX_PEERS = 12

#Is a NetworkedMultiplayerENet: Is what is 
var peer: NetworkedMultiplayerENet = null
var players_ready = []

#Only host will have everyones real roles, everyone else just stores there own
var players = {}

#Your name and team
var player_name = "yo mama"
var my_team


#LOBBY SIGNALS
signal player_list_changed()
signal connection_failed()
signal connection_succeeded()
signal game_ended()
signal game_error(what)

func _ready():
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_on_player_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_ok")
	get_tree().connect("connection_failed", self, "_on_connected_fail")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")

func host_game(new_player_name):
	player_name = new_player_name
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PEERS)
	get_tree().set_network_peer(peer)
	register_player(player_name)

func join_game(ip, new_player_name):
	player_name = new_player_name
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(peer)
	register_player(player_name)
	
# This is called on all clients (even listen server) whenever someone connects
func _on_player_connected(id):
	rpc_id(id, "register_player", player_name)
	
remote func register_player(player_name):
	print("Registering player " + player_name)
	var id = get_tree().get_rpc_sender_id()
	id = get_tree().get_network_unique_id() if id == 0 else id
	players[id] = {"name": player_name, "team": GameState.TEAM.ESCAPEE}
	emit_signal("player_list_changed")
		
func _on_connected_ok():
	emit_signal("connection_succeeded")
	
func _on_player_disconnected(id):
	print("player disconnected")
	GameState.remove_player(id)
	unregister_player(id)
	
func unregister_player(id):
	if players.has(id):
		players.erase(id)
	emit_signal("player_list_changed")
	
func _on_connected_fail():
	print("connection failed")
	emit_signal("connection_failed")
	
func _on_server_disconnected():
	# Disconnect self from network
	get_tree().network_peer = null
	# Clear players
	players.clear()
	# Reload main menu
	GameState.load_menu()
	emit_signal("game_error")

func get_player_list():
	return players

func start_game():
		
	#print(players)
	
	#Assert means that if this client is not the host --> Stop the code
	#This means only the host should be running this code (This is a SERVER ONLY COMMAND)
	assert(get_tree().is_network_server())
	
	#Signal other plays to start pre-game code
	for p in players:
		rpc_id(p, "pre_start_game")

	#Start own pre-game code
	pre_start_game()

#Run after start button is pressed but before it actually starts
remote func pre_start_game():
	GameState.start_new_game()
	
	
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
		
		
		
		
