extends Control

onready var name_prompt = $HBoxContainer/VBoxContainer/NamePrompt
onready var error = $Error
onready var joining_popup = $JoiningPopup
onready var ip_address = $JoiningPopup/VBoxContainer/IP

var player_name: String

signal hosting_game
signal joining_game

func _ready():
	error.text = ""

func _on_HostButton_pressed():
	if check_name():
		print("hosting")
		gamestate.host_game(player_name)
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
	var ip = ip_address.text
	if not ip.is_valid_ip_address():
		error.text = "Please enter a valid IP address."
		ip_address.text = ""
		return
		
	gamestate.join_game(ip, player_name)
