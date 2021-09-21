extends Control


func _ready():
	# Called every time the node is added to the scene.
	"""
	gamestate.connect("game_ended", self, "_on_game_ended")
	"""
	Network.connect("game_error", self, "_on_game_error")
	Network.connect("player_list_changed", self, "refresh_lobby")
	Network.connect("connection_succeeded", self, "_on_connection_success")
	Network.connect("connection_failed", self, "_on_connection_failed")
	
	$LobbyPanel.hide()
	$ConnectingPanel.show()
	

func _on_game_error():
	$LobbyPanel.hide()
	$ConnectingPanel.show()
	$ErrorLabel.text = "SERVER DISCONNECTED"
	$ConnectingPanel/HostButton.disabled = false
	$ConnectingPanel/JoinButton.disabled = false

func _on_connection_success():
	refresh_lobby()
	$ConnectingPanel.hide()
	$LobbyPanel.show()
	
func _on_connection_failed():
	$ErrorLabel.text = "CONNECTION FAILED."
	$ConnectingPanel/HostButton.disabled = false
	$ConnectingPanel/JoinButton.disabled = false
	
func refresh_lobby():
	#Clear current lobby list and add self
	$LobbyPanel/PlayerList.clear()
	$LobbyPanel/PlayerList.add_item(Network.player_name + " (You)")
	
	#Add all of the other players
	var player_list = Network.get_player_list()
	print("List: " + str(player_list))
	player_list.sort()
	for p in player_list:
		$LobbyPanel/PlayerList.add_item(p)
		print("Adding to UI: " + p)

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
	
	Network.host_game(name)
	refresh_lobby()
	
func _on_JoinButton_pressed():
	
	#Get inputs
	var name = $ConnectingPanel/NamePrompt.text
	var ip = $ConnectingPanel/IPPrompt.text
	
	#Check for valid inputs
	if name == "":
		$ErrorLabel.text = "INVALID NAME"
		return
	if ip == "":
		# Autofill to localhost ip
		ip = "127.0.0.1"
	elif not ip.is_valid_ip_address():
		$ErrorLabel.text = "INVALID IP"
		return
	
	#Disable further inputs until connection attempt is processed
	$ErrorLabel.text = ""
	$ConnectingPanel/HostButton.disabled = true
	$ConnectingPanel/JoinButton.disabled = true
	
	#Attempt to Connect
	Network.join_game(ip, name)
	
	$LobbyPanel/StartButton.disabled = true
	
func _on_StartButton_pressed():
	Network.start_game()


	
