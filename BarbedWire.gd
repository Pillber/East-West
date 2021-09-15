extends Area2D

puppet var puppet_pos = Vector2()

func _ready():
	pass

	
func _process(delta):
	if is_network_master():
		rset("puppet_pos", position)
	else:
		position = puppet_pos


func _on_BarbedWire_body_entered(body):
	body.move_speed /= 2


func _on_BarbedWire_body_exited(body):
	body.move_speed *= 2
