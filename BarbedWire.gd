extends "res://GameObject.gd"



func _ready():
	object_type = "BarbedWire"
	sync_position()
	


func _on_BarbedWire_body_entered(body):
	body.move_speed /= 2


func _on_BarbedWire_body_exited(body):
	body.move_speed *= 2
