extends "res://SectionTemplate.gd"

func _ready():
	
	#Make server/host the master of all non-player objects
	master_game_objects_to_host()
	
	
	spawn_players()
	
	
	
	
func player_spotted(who):
	print(str(who) + " was spotted")
	

	
	
func spawn_players():
	#Spawn my player
	var my_id = get_tree().get_network_unique_id()
	$Players.add_child(new_player(my_id, gamestate.player_name))
	
	# Add all other players to the game scene
	for p in gamestate.players:
		$Players.add_child(new_player(p, gamestate.players[p]))

		

