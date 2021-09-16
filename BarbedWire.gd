extends "res://GameObject.gd"



func _ready():
	pass

	
func _process(delta):
	sync_position()


func _on_BarbedWire_body_entered(body):
	body.move_speed /= 2


func _on_BarbedWire_body_exited(body):
	body.move_speed *= 2
