extends Node

enum TEAM{LOYALIST, ESCAPEE}

var current_section: String = "MainMenu"
var starting_section = "NoMansLand"
var loyalist_count = 1

#Holds all player names and there role
var player_roles = {}
var my_role
var group_sus



func start_new_game():
	#Only server should be setting roles, everyone else justs copies	
	if get_tree().is_network_server():
		assign_roles()
		rpc("update_roles", player_roles)
		
	load_section(starting_section)
	

remotesync func update_roles(roles):
	player_roles = roles
	my_role = player_roles[get_tree().get_network_unique_id()]

func assign_roles():
	#Copy players from network to game & set them all to escapee
	player_roles[get_tree().get_network_unique_id()] = TEAM.ESCAPEE
	for p in Network.players:
		player_roles[p] = TEAM.ESCAPEE
	
	#Choose some to be loyalist at random
	#Making sure to not choose same person twice
	randomize()
	for l in range(loyalist_count):
		while true:
			var random_id = player_roles.keys()[int(rand_range(0, player_roles.size()))]
			if player_roles[random_id] == TEAM.ESCAPEE:
				player_roles[random_id] = TEAM.LOYALIST
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
