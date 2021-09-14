extends Area2D

puppet var puppet_pos = Vector2()

var follow_path = true
var follow_speed = 100

func _ready():
	pass

func _process(delta):
	if is_network_master():
		rset("puppet_pos", position)
	else:
		position = puppet_pos
	
	


func _on_Spotlight_body_entered(body):
	get_owner().player_spotted(body.name)
