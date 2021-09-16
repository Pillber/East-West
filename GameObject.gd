extends Node2D


var object_type
puppet var puppet_pos = Vector2()

func sync_position():
	if self.is_network_master():
		rset("puppet_pos", global_position)
	else:
		global_position = puppet_pos
		
