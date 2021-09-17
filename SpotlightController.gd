extends "res://GameObject.gd"

var follow_path = true
var follow_speed = 100

func _ready():
	object_type = "Spotlight"

func _process(delta):
	sync_position()


func _on_Spotlight_body_entered(body):
	get_owner().spot_player(body.name)

