extends Node2D


func _ready():
	pass
	"""
	# Add this clients player to the game scene
	var my_player = load("res://Player.tscn").instance()
	my_player.set_name(str(get_tree().get_network_unique_id()))
	my_player.set_in_game_name(player_name)
	my_player.set_network_master(get_tree().get_network_unique_id())
	get_node("/root/Game").add_child(my_player)
	
	# Add all other players to the game scene
	for p in players:
		var player = load("res://Player.tscn").instance()
		player.set_name(str(p))
		player.set_network_master(p)
		player.set_in_game_name(players[p])
		get_node("/root/Game").add_child(player) 
		get_node("/root/Game/" + str(p)).position += Vector2(100, 0)
	"""
