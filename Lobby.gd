extends Control

onready var start_button = $StartButton
onready var player_list = $HBoxContainer/PlayersPanel/VBoxContainer/PlayerList
onready var ready_button = $HBoxContainer/PlayersPanel/VBoxContainer/ReadyButton
onready var message_prompt = $HBoxContainer/MessagesPanel/VBoxContainer/HBoxContainer/MessagePrompt
onready var messages = $HBoxContainer/MessagesPanel/VBoxContainer/Messages

export var ready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Network.connect("player_list_changed", self, "update_player_list")
	Network.connect("message_received", self, "_on_message_received")
	
func init():
	if get_tree().is_network_server():
		start_button.visible = true
		start_button.disabled = true
	messages.append_bbcode("Hosted on IP " + Network.ip)
	update_player_list()

func update_player_list():
	player_list.clear()
	var player_line: String = Network.player_name
	if ready:
		player_line += " (Ready)"
	player_list.add_item(player_line, null, false)
	for player in Network.get_player_list():
		player_line = player.Name
		if player.Ready:
			player_line += " (Ready)"
		player_list.add_item(player_line, null, false)
		
	check_all_player_ready()
	
func check_all_player_ready():
	if not ready:
		start_button.disabled = true
		return
	for player in Network.get_player_list():
		if not player.Ready:
			start_button.disabled = true
			return
	if get_tree().is_network_server():
		start_button.disabled = false
		
func send_message():
	var message = message_prompt.text
	if message == "":
		return
	messages.append_bbcode("\n[" + Network.player_name + "]: " + message)
	message_prompt.text = ""
	Network.send_message(message)
	
func _on_message_received(id, message):
	var sender_name = Network.players[id].Name
	messages.append_bbcode("\n[" + sender_name + "]: " + message)
	
func clear():
	player_list.clear()
	messages.clear()

func _on_ReadyButton_pressed():
	if not ready:
		ready = true
		ready_button.text = "Unready"
	else:
		ready = false
		ready_button.text = "Ready"
	Network.change_player_ready()
	update_player_list()


func _on_SendButton_pressed():
	send_message()

func _on_MessagePrompt_text_entered(new_text):
	send_message()


func _on_StartButton_pressed():
	Network.start_game()
