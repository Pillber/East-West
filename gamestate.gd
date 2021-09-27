extends Node

enum TEAM{ESCAPEE, LOYALIST}

var current_section: String = "MainMenu"
var starting_section = "NoMansLand"
var loyalist_count = 1

var group_sus = 0


func start_new_game():
	#Host assigns teams and other variables and sends them to other players
	if get_tree().is_network_server():
		assign_teams()
		for p in Network.players:
			rpc_id(p, "update_player_teams", Network.players)
			
		rpc("load_section", starting_section)
			
remotesync func update_player_teams(data):
	Network.my_team = data[get_tree().get_network_unique_id()]["team"]
	
	#Escapee's only get their own team, loyalist get everyones team
	if Network.my_team == GameState.TEAM.LOYALIST:
		Network.players = data.duplicate(true)

#Populates hosts player_data with player data
func assign_teams():
	randomize()
	var ids: Array = Network.players.keys()
	
	for l in range(loyalist_count if loyalist_count <= ids.size() else ids.size()):
		var id = ids[rand_range(0, ids.size())]
		Network.players[id]["team"] = GameState.TEAM.LOYALIST
		ids.remove(ids.find(id))

remotesync func load_section(section_name):
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
		
func disconnect_player(player_id):
	get_tree().get_root().get_node(current_section).remove_player(player_id)

func alive_player_count():
	var a = 0
	for p in Network.players:
		a = a+1 if Network.players[p]["alive"] else a
	return a

func start_vote():
	print("Starting vote")
