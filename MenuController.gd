extends Control


func _ready():
	# Called every time the node is added to the scene.
	"""
	gamestate.connect("connection_failed", self, "_on_connection_failed")
	gamestate.connect("connection_succeeded", self, "_on_connection_success")
	gamestate.connect("player_list_changed", self, "refresh_lobby")
	gamestate.connect("game_ended", self, "_on_game_ended")
	gamestate.connect("game_error", self, "_on_game_error")
	"""
	
	$LobbyPanel.hide()
	$ConnectingPanel.show()
	



func _on_HostButton_pressed():
	#Get inputs
	var name = $ConnectingPanel/NamePrompt.text
	
	#Check for valid input
	if name == "":
		$ErrorLabel.text = "INVALID NAME"
		return
		
	$LobbyPanel.show()
	$ConnectingPanel.hide()
	$ErrorLabel.text = ""
	
	gamestate.host_game(name)
	Refresh_Lobby()
	
func _on_JoinButton_pressed():
	#Get inputs
	var name = $ConnectingPanel/NamePrompt.text
	var ip = $ConnectingPanel/IPPrompt.text
	
	#Check for valid inputs
	if name == "":
		$ErrorLabel.text = "INVALID NAME"
		return
	if not ip.is_valid_ip_address():
		$ErrorLabel.text = "INVALID IP"
		return
	
	#Disable further inputs until connection attempt is processed
	$ErrorLabel.text = ""
	$ConnectingPanel/HostButton.disabled = true
	$ConnectingPanel/JoinButton.disabled = true
	
	#Attempt to Connect
	gamestate.join_game(ip, name)
	
func Refresh_Lobby():
	#Clear current lobby list and add self
	$LobbyPanel/PlayerList.clear()
	$LobbyPanel/PlayerList.add_item(gamestate.player_name + " (You)")
	
	#Add all of the other players
	var player_list = gamestate.get_player_list()
	player_list.sort()
	for p in player_list:
		$LobbyPanel/PlayerList.add_item(p)
	
func _on_StartButton_pressed():
	gamestate.start_game()
