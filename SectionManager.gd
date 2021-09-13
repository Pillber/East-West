extends Node

var current_section = "MainMenu"

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
	
