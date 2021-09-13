extends Control

onready var name_prompt = $HBoxContainer/VBoxContainer/NamePrompt
onready var error = $Error
onready var joining_popup = $JoiningPopup
onready var ip_address = $JoiningPopup/VBoxContainer/IP

var player_name: String
var ip: String

signal hosting_game()
signal joining_game()

func _ready():
	
	Network.connect("connection_failed", self, "_on_connection_failed")
	Network.connect("connection_succeeded", self, "_on_connection_succeeded")
	
	
	error.text = ""	

func _on_HostButton_pressed():
	if check_name():
		print("hosting")
		Network.host_game(player_name)
		emit_signal("hosting_game")


func _on_JoinButton_pressed():
	if check_name():
		print("joining")
		joining_popup.popup()
		emit_signal("joining_game")


func check_name():
	player_name = name_prompt.text
	if player_name == "":
		error.text = "Please enter a name."
		return false
	return true


func _on_JoinPopupButton_pressed():
	ip = ip_address.text
	if not ip.is_valid_ip_address():
		error.text = "Please enter a valid IP address."
		ip_address.text = ""
		return
		
	joining_popup.get_node("VBoxContainer/JoinPopupButton").disabled = true
	error.text = "Joining..."
	Network.join_game(ip, player_name)

func _on_connection_failed():
	error.text = "Unable to connect to " + ip
	joining_popup.get_node("VBoxContainer/JoinPopupButton").disabled = false
	
func _on_connection_succeeded():
	#TODO: switch to lobby screen
	pass
