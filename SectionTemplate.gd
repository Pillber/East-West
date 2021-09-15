extends Node2D


func spawn_object(object):
	pass
	
func new_player(master_id: int, name: String):
	var player_instance = load("res://Player.tscn").instance()
	player_instance.set_name(str(master_id))
	player_instance.set_network_master(master_id)
	player_instance.set_in_game_name(name)
	return player_instance
	



#Go through all objects not controlled by a player and set their network master to host
func master_game_objects_to_host():
	#If host
	if get_tree().is_network_server():
		#Go through all children of this sections scene
		for c in get_children():
			#Set self(host) to master of these objects
			c.set_network_master(get_tree().get_network_unique_id(), true)
