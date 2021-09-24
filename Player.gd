extends KinematicBody2D

onready var camera = $Camera2D

export var move_speed = 100

puppet var puppet_position: Vector2
puppet var puppet_input: Vector2

var team

func _ready():
	if team == GameState.TEAM.LOYALIST:
		$Sprite.modulate = Color(0, 1, 0)
	
	position = Vector2(100, 100)
	
	# Make sure that the right camera is active for the right player
	if is_network_master():
		camera.make_current()


func _physics_process(delta):
	
	var input = Vector2()
	
	if self.is_network_master():
		
		if Input.is_action_pressed("move_up"):
			input += Vector2.UP
		if Input.is_action_pressed("move_down"):
			input += Vector2.DOWN
		if Input.is_action_pressed("move_right"):
			input += Vector2.RIGHT
		if Input.is_action_pressed("move_left"):
			input += Vector2.LEFT
		
		input = input.normalized()
		
		rset("puppet_position", position)
		rset("puppet_input", input)
	else:
		position = puppet_position
		input = puppet_input
		
	move_and_slide(input * move_speed)

func set_in_game_name(new_name):
	$Name.text = new_name
