extends Node2D


remotesync func spawn_object(path: String, position: Vector2):
	var instance = load(path).instance()
	instance.position = position
	$LevelObjects.add_child(instance)	
	
	
func new_player(master_id: int, name: String):
	var player_instance = load("res://Player.tscn").instance()
	player_instance.set_name(str(master_id))
	player_instance.set_network_master(master_id)
	player_instance.set_in_game_name(name)
	return player_instance
	
	
func remove_player(player_id):
	get_node("/Players/" + player_id).queue_free()



