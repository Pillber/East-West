extends "res://GameObject.gd"



var follow_path = true
var follow_speed = 100





func _process(delta):
	sync_position()


func _on_Spotlight_body_entered(body):
	get_owner().player_spotted(body.name)
