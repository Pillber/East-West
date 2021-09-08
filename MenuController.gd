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
	



func _on_HostButton_pressed():
	pass # Replace with function body.


func _on_JoinButton_pressed():
	#Get inputs
	var name = $ConnectingPanel/Labels/NameLabel.text
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
	
	
	
	
	
