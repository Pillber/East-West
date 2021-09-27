extends "res://SectionTemplate.gd"

onready var start_zone = $StartZone/Shape
onready var end_zone = $EndZone/Shape

var players_escaped = 0

func _ready():
	spawn_barbed_wire()
	spawn_players()
	

func spawn_players():
	if get_tree().is_network_server():
		# Add all players to the game scene
		for p in Network.players:
			rpc("spawn_player", p, Network.players[p]["name"], get_random_start_pos())

#Gets random point inside starting area
func get_random_start_pos():
	randomize()
	var x = rand_range(start_zone.global_position.x-start_zone.shape.extents.x, start_zone.global_position.x+start_zone.shape.extents.x)
	var y = rand_range(start_zone.global_position.y-start_zone.shape.extents.y, start_zone.global_position.y+start_zone.shape.extents.y)
	return Vector2(x, y)

func spawn_barbed_wire():
	if get_tree().is_network_server():
		randomize()
		for i in range(3):
			rpc("spawn_object", "res://BarbedWire.tscn", Vector2(rand_range(100, 600), rand_range(100, 400)))

func player_escaped(who):
	if get_tree().is_network_server():
		players_escaped += 1
		rpc("remove_player", who)
		if(players_escaped == GameState.alive_player_count()):
			section_over()

func spot_player(who):
	if get_tree().is_network_server():	
		GameState.group_sus += 10

remotesync func remove_player(player_id):
	print("Removing Player")
	$Players.get_node(str(player_id)).queue_free()

func _on_EndZone_body_entered(body):
	if(body.position != Vector2(0, 0)):
		player_escaped(body.name)

func section_over():
	GameState.start_vote()


func disconnect_player(who):
	remove_player(who)
