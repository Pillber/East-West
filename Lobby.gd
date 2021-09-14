extends Control

onready var start_button = $StartButton
onready var player_list = $HBoxContainer/PlayersPanel/VBoxContainer/PlayerList
onready var ready_button = $HBoxContainer/PlayersPanel/VBoxContainer/ReadyButton

export var ready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Network.connect("player_list_changed", self, "update_player_list")
	
	if get_tree().is_network_server():
		start_button.visible = true
		start_button.disabled = true
		
	update_player_list()

func update_player_list():
	player_list.clear()
	var player_line: String = Network.player_name
	if ready:
		player_line += " (Ready)"
	player_list.add_item(player_line, null, false)
	for player in Network.get_player_list():
		print(player)
		player_line = player.Name
		if player.Ready:
			player_line += " (Ready)"
		player_list.add_item(player_line, null, false)


func _on_ReadyButton_pressed():
	if not ready:
		ready = true
		ready_button.text = "Unready"
	else:
		ready = false
		ready_button.text = "Ready"
	Network.change_player_ready()
	update_player_list()
