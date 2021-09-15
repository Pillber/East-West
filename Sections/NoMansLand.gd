extends "res://SectionTemplate.gd"

func _ready():
	#Master all level objects to host
	master_game_objects_to_host()
	
	spawn_players()
	spawn_barbed_wire(3)

func spawn_barbed_wire(x: int):
	randomize()
	for i in range(x):
		spawn_object("res://BarbedWire.tscn", Vector2(rand_range(300, 800), rand_range(300, 800)))
	
func player_spotted(who):
	print(str(who) + " was spotted")
	
	
func spawn_players():
	#Spawn my player
	var my_id = get_tree().get_network_unique_id()
	$Players.add_child(new_player(my_id, gamestate.player_name))
	
	# Add all other players to the game scene
	for p in gamestate.players:
		$Players.add_child(new_player(p, gamestate.players[p]))

		

