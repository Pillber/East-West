extends Node2D


remotesync func spawn_object(path: String, position: Vector2):
	var instance = load(path).instance()
	instance.position = position
	$LevelObjects.add_child(instance)	
	
	
remotesync func spawn_player(master_id: int, name: String, start_pos: Vector2):
	var player_instance = load("res://Player.tscn").instance()
	player_instance.set_name(str(master_id))
	player_instance.set_network_master(master_id)
	player_instance.set_in_game_name(name)
	
	#This makes sure that the player doesn't trip any area's at 0, 0 before
	#being moved to its starting position
	player_instance.global_position = Vector2(-100, -100)
	
	$Players.add_child(player_instance)
	player_instance.position = start_pos
	
#Unique functionility added to each child scene
func remove_player(player_id):
	print("Player: " + str(player_id) + " being removed!")



