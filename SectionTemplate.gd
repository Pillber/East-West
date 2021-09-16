extends Node2D


func spawn_object(path: String, position: Vector2):
	var instance = load(path).instance()
	instance.set_network_master(1)
	instance.position = position
	$LevelObjects.add_child(instance)	
	
	
func new_player(master_id: int, name: String):
	var player_instance = load("res://Player.tscn").instance()
	player_instance.set_name(str(master_id))
	player_instance.set_network_master(master_id)
	player_instance.set_in_game_name(name)
	return player_instance
	



#Go through all objects not controlled by a player and set their network master to host
func master_objects_to_host():
	for c in get_children():
		#Set self(host) to master of these objects
		c.set_network_master(1, true)
