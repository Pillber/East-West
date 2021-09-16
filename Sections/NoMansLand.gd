extends "res://SectionTemplate.gd"

func _ready():
	#Master all default objects to host
	#master_objects_to_host()
	spawn_players()
	


func spot_player(who):
	rpc("player_spotted", who)

remote func player_spotted(who):
	print(who)

	
func spawn_players():
	#Spawn my player
	var my_id = get_tree().get_network_unique_id()
	$Players.add_child(new_player(my_id, gamestate.player_name))
	
	# Add all other players to the game scene
	for p in gamestate.players:
		$Players.add_child(new_player(p, gamestate.players[p]))

		

