extends "res://SectionTemplate.gd"

func _ready():
	spawn_barbed_wire()
	#Master all default objects to host
	spawn_players()
	


func spawn_barbed_wire():
	if get_tree().is_network_server():
		randomize()
		for i in range(3):
			rpc("spawn_object", "res://BarbedWire.tscn", Vector2(rand_range(100, 300), rand_range(100, 300)))

func spot_player(who):
	if get_tree().is_network_server():	
		rpc("player_spotted", who)
	

remotesync func player_spotted(who):
	print(who)

	
func spawn_players():
	#Spawn my player
	var my_id = get_tree().get_network_unique_id()
	$Players.add_child(new_player(my_id, gamestate.player_name))
	
	# Add all other players to the game scene
	for p in gamestate.players:
		$Players.add_child(new_player(p, gamestate.players[p]))

		

