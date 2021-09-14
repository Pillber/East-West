extends PathFollow2D




func _process(delta):
	if get_child_count() >= 1:
		for c in get_children():
			if c.is_network_master() && c.follow_path:
				offset += c.follow_speed * delta
				
				
		
