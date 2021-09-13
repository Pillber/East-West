extends Area2D

onready var path_point = $Path/PathFollower
puppet var puppet_pos = Vector2()

func _ready():
	pass

func _process(delta):
	if is_network_master():
		path_point.offset += 100 * delta
		position = path_point.position
		
		rset("puppet_pos", position)
	else:
		position = puppet_pos
	
	


func _on_Spotlight_body_entered(body):
	get_owner().player_spotted(body.name)
