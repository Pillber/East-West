extends Node2D


func _ready():
	
	#Make server/host the master of all non-player objects
	master_game_objects_to_host()
	
	
	spawn_players()
	
	
	
	
func player_spotted(who):
	print(str(who) + " was spotted")
	
	
	
func spawn_players():
	#Add my player
	var my_player = load("res://Player.tscn").instance()
	my_player.set_name(str(get_tree().get_network_unique_id()))
	my_player.set_in_game_name(gamestate.player_name)
	my_player.set_network_master(get_tree().get_network_unique_id())
	$Players.add_child(my_player)
	
	# Add all other players to the game scene
	for p in gamestate.players:
		var player = load("res://Player.tscn").instance()
		player.set_name(str(p))
		player.set_network_master(p)
		player.set_in_game_name(gamestate.players[p])
		player.position = Vector2(100, 100)
		$Players.add_child(player) 
		

		
#Go through all objects not controlled by a player and set their network master to host
func master_game_objects_to_host():
	#If host
	if get_tree().is_network_server():
		#Go through all children of this sections scene
		for c in get_children():
			#Set self(host) to master of these objects
			c.set_network_master(get_tree().get_network_unique_id(), true)
