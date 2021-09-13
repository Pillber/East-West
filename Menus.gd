extends Control

onready var main_menu = $MainMenu
onready var host_or_join = $HostOrJoin

func _ready():

	#Network.connect("game_ended", self, "_on_game_ended")
	#Network.connect("game_error", self, "_on_game_error")

	Network.connect("player_list_changed", self, "refresh_lobby")
	Network.connect("connection_succeeded", self, "_on_connection_success")
	
	main_menu.connect("play_pressed", self, "show_host_or_join")

	host_or_join.hide()
	main_menu.show()

func show_host_or_join():
	main_menu.hide()
	host_or_join.show()
	
func _on_connection_success():
	pass

