extends KinematicBody2D

export var move_speed = 100

func _ready():
	$Name.text = gamestate.player_name
	position = Vector2(100, 100)


func _physics_process(delta):
	var input = Vector2()
	
	if Input.is_action_pressed("move_up"):
		input += Vector2.UP
	if Input.is_action_pressed("move_down"):
		input += Vector2.DOWN
	if Input.is_action_pressed("move_right"):
		input += Vector2.RIGHT
	if Input.is_action_pressed("move_left"):
		input += Vector2.LEFT
	
	input = input.normalized()
	
	move_and_slide(input * move_speed)
