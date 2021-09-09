extends Node

const DEFAULT_PORT = 10567
# Max number of players.
const MAX_PEERS = 12

#Is a NetworkedMultiplayerENet: Is what is 
var peer = null

var players = {}
var player_name = "Jonathan"
var players_ready = []


#LOBBY SIGNALS
signal player_list_changed()
signal connection_failed()
signal connection_succeeded()
signal game_ended()
signal game_error(what)

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func host_game(new_player_name):
	player_name = new_player_name
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PEERS)
	get_tree().set_network_peer(peer)

func join_game(ip, new_player_name):
	player_name = new_player_name
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(peer)

func get_player_list():
	return players.values()

func start_game():
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
	
	# Change to game scene while keeping lobby scene loading
	var Game = load("res://Game.tscn").instance()
	get_tree().get_root().add_child(Game)
	get_tree().get_root().get_node("MainMenu").hide()

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
		
		
		
		
