extends Control

onready var main_menu = $MainMenu
onready var host_or_join = $HostOrJoin
onready var lobby = $Lobby

func _ready():

	#Network.connect("game_ended", self, "_on_game_ended")
	#Network.connect("game_error", self, "_on_game_error")

	Network.connect("show_lobby", self, "show_lobby")
	Network.connect("server_closed", self, "show_host_or_join")
	
	main_menu.connect("play_pressed", self, "show_host_or_join")

	host_or_join.hide()
	lobby.hide()
	main_menu.show()

func show_host_or_join():
	main_menu.hide()
	lobby.hide()
	lobby.clear()
	host_or_join.show()
	
func show_lobby():
	host_or_join.hide()
	lobby.init()
	lobby.show()
	
