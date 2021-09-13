extends Control

onready var lobby = $LobbyPanel
onready var connecting = $ConnectingPanel
onready var main_menu = $MainMenu
onready var error = $ErrorLabel
onready var host_or_join = $HostOrJoin

func _ready():
	# Called every time the node is added to the scene.
	"""
	gamestate.connect("game_ended", self, "_on_game_ended")
	gamestate.connect("game_error", self, "_on_game_error")
	"""
	gamestate.connect("player_list_changed", self, "refresh_lobby")
	gamestate.connect("connection_succeeded", self, "_on_connection_success")
	gamestate.connect("connection_failed", self, "_on_connection_failed")
	
	main_menu.connect("play_pressed", self, "show_connecting")
	
	lobby.hide()
	connecting.hide()
	host_or_join.hide()
	main_menu.show()

func show_connecting():
	main_menu.hide()
	host_or_join.show()
	
func _on_connection_success():
	refresh_lobby()
	connecting.hide()
	lobby.show()
	
func _on_connection_failed():
	error.text = "CONNECTION FAILED."
	connecting.get_node("HostButton").disabled = false
	connecting.get_node("JoinButton").disabled = false
	
func refresh_lobby():
	var lobby_list = lobby.get_node("PlayerList")
	#Clear current lobby list and add self
	lobby_list.clear()
	lobby_list.add_item(gamestate.player_name + " (You)")
	
	#Add all of the other players
	var player_list = gamestate.get_player_list()
	print("List: " + str(player_list))
	player_list.sort()
	for p in player_list:
		lobby_list.add_item(p)
		print("Adding to UI: " + p)

func _on_HostButton_pressed():
	#Get inputs
	var name = connecting.get_node("NamePrompt").text
	
	#Check for valid input
	if name == "":
		error.text = "INVALID NAME"
		return
		
	lobby.show()
	connecting.hide()
	error.text = ""
	
	gamestate.host_game(name)
	refresh_lobby()
	
func _on_JoinButton_pressed():
	
	#Get inputs
	var name = connecting.get_node("NamePrompt").text
	var ip = connecting.get_node("IPPrompt").text
	
	#Check for valid inputs
	if name == "":
		error.text = "INVALID NAME"
		return
	if not ip.is_valid_ip_address():
		error.text = "INVALID IP"
		return
	
	#Disable further inputs until connection attempt is processed
	error.text = ""
	connecting.get_node("HostButton").disabled = true
	connecting.get_node("JoinButton").disabled = true
	
	#Attempt to Connect
	gamestate.join_game(ip, name)
	
	lobby.get_node("StartButton").disabled = true
	
func _on_StartButton_pressed():
	gamestate.start_game()


	
