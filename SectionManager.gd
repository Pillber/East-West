extends Node

var current_section: String = "MainMenu"

func load_section(section_name):
	#Load section we are looking for
	var section = load("res://Sections/" + str(section_name) + ".tscn").instance()
	
	#Add the section to root
	get_tree().get_root().add_child(section)
	
	#If the current section is the main menu: just hide it
	#Else: remove the scene from the root
	if current_section == "MainMenu":
		get_tree().get_root().get_node(current_section).hide()
	else:
		get_tree().get_root().get_node(current_section).queue_free()
	
	#Update what the current section
	current_section = section_name

func load_menu():
	# Make sure that the menu isnt being loaded from the menu
	if current_section != "MainMenu":
		get_tree().get_root().get_node(current_section).queue_free()
		current_section = "MainMenu"
		get_tree().get_root().get_node(current_section).show()
		
func remove_player(player_id):
	get_tree().get_root().get_node(current_section).remove_player(player_id)
