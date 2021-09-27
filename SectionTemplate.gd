extends Node2D


remotesync func spawn_object(path: String, position: Vector2):
	var instance = load(path).instance()
	$LevelObjects.add_child(instance)	
	instance.position = position
	
remotesync func spawn_player(master_id: int, name: String, start_pos: Vector2):
	var player_instance = load("res://Player.tscn").instance()
	player_instance.set_name(str(master_id))
	player_instance.set_network_master(master_id)
	player_instance.set_in_game_name(name)
	player_instance.team = Network.players[master_id]["team"]
		
	$Players.add_child(player_instance)
	player_instance.position = start_pos
	
#Unique functionility added to each child scene
func remove_player(player_id):
	print("Player: " + str(player_id) + " being removed!")



