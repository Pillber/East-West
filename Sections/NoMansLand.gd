extends "res://SectionTemplate.gd"

onready var start_zone = $LevelObjects/StartZone/Shape
onready var end_zone = $LevelObjects/EndZone/Shape

func _ready():
	spawn_barbed_wire()
	spawn_players()
	


func spawn_barbed_wire():
	if get_tree().is_network_server():
		randomize()
		for i in range(3):
			rpc("spawn_object", "res://BarbedWire.tscn", Vector2(rand_range(100, 600), rand_range(100, 400)))

func spot_player(who):
	if get_tree().is_network_server():	
		rpc("player_spotted", who)
	
remotesync func player_spotted(who):
	print(who)

func spawn_players():
	if get_tree().is_network_server():
		#Spawn my player
		var my_id = get_tree().get_network_unique_id()
		rpc("spawn_player", my_id, gamestate.player_name, get_random_start_pos())
		
		# Add all other players to the game scene
		for p in gamestate.players:
			rpc("spawn_player", p, gamestate.players[p], get_random_start_pos())

#Gets random point inside starting area
func get_random_start_pos():
	randomize()
	var x = rand_range(start_zone.global_position.x-start_zone.shape.extents.x, start_zone.global_position.x+start_zone.shape.extents.x)
	var y = rand_range(start_zone.global_position.y-start_zone.shape.extents.y, start_zone.global_position.y+start_zone.shape.extents.y)
	return Vector2(x, y)

#Must be overriden in child scripts
func remove_player(player_id):
	$Players.get_node(str(player_id)).queue_free()

