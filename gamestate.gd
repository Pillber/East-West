extends Node

enum TEAM{LOYALIST, ESCAPEE}

class Player:
	var team
	var name: String
	#Other player attributes could be added here
	#var apperance
	#var 

var current_section: String = "MainMenu"
var starting_section = "NoMansLand"
var loyalist_count = 1

#Holds all player names and there role
var player_data = {}
var my_data
var group_sus



func start_new_game():
	#Only server should be setting roles, everyone else justs copies	
	if get_tree().is_network_server():
		create_players()
		rpc("update_player_data", player_data)
		
	load_section(starting_section)
	

remotesync func update_player_data(data):
	player_data = data
	my_data = player_data[get_tree().get_network_unique_id()]

func create_players():
	
	#Hosts Player
	player_data[1] = Player.new()
	player_data[1].name = Network.player_name
	player_data[1].team = TEAM.ESCAPEE
	
	#Everyone elses players
	for p in Network.players:
		player_data[p] = Player.new()
		player_data[p].name = Network.players[p]
		player_data[p].team = TEAM.ESCAPEE
		
	
	#Choose some people to be loyalist
	if loyalist_count >= player_data.size():
		return
	randomize()
	for l in range(loyalist_count):
		while true:
			var random_id = player_data.keys()[int(rand_range(0, player_data.size()))]
			if player_data[random_id].team == TEAM.ESCAPEE:
				player_data[random_id].team = TEAM.LOYALIST
				break

func load_section(section_name):
	#Load section we are looking for
	var section = load("res://Sections/" + str(section_name) + ".tscn").instance()
	
	#Add the section to root
	get_tree().get_root().add_child(section)
	
	#If the current section is the main menu: just hide it
	#Else: remove the scene from the root
	if current_section == "MainMenu":
		get_tree().get_root().get_node(current_section).hide()
	else:
		get_tree().get_root().get_node(current_section).queue_free()
	
	#Update what the current section
	current_section = section_name

func load_menu():
	# Make sure that the menu isnt being loaded from the menu
	if current_section != "MainMenu":
		get_tree().get_root().get_node(current_section).queue_free()
		current_section = "MainMenu"
		get_tree().get_root().get_node(current_section).show()
		
func remove_player(player_id):
	get_tree().get_root().get_node(current_section).remove_player(player_id)
	player_data.erase(player_id)
